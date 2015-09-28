# -*- coding: utf-8 -*-
#
# Copyright (c) 2015, Alcatel-Lucent Inc
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the copyright holder nor the names of its contributors
#       may be used to endorse or promote products derived from this software without
#       specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

{% for api in specification.children_apis %}
from ..fetchers import {{ sdk_class_prefix }}{{ api.plural_name }}Fetcher{% endfor %}
from bambou import NURESTRootObject{% if specification.has_time_attribute %}
from time import time{% endif %}


class {{ sdk_class_prefix }}{{ specification.name }}(NURESTRootObject):
    """ Represents a user that can login to the {{ product_accronym }}.

        Warning:
            This file has been autogenerated. You should never change it.
            Override {{ sdk_name }}.{{ sdk_class_prefix }}{{ specification.name }} instead.
    """

    __rest_name__ = u"{{ root_api }}"

    def __init__(self, **kwargs):
        """ Initializes a {{ specification.name }} instance

            Notes:
                You can specify all parameters while calling this methods.
                A special argument named `data` will enable you to load the
                object from a Python dictionary

            Examples:
                >>> {{ specification.name.lower() }} = {{ sdk_class_prefix }}{{ specification.name }}(id=u'xxxx-xxx-xxx-xxx', name=u'{{ specification.name }}')
                >>> {{ specification.name.lower() }} = {{ sdk_class_prefix }}{{ specification.name }}(data=my_dict)
        """

        super({{ sdk_class_prefix }}{{ specification.name }}, self).__init__()

        # Read/Write Attributes
        {% for attribute in specification.attributes %}
        self._{{ attribute.local_name|lower }} = None{% endfor %}
        {% for attribute in specification.attributes %}
        self.expose_attribute(local_name=u"{{ attribute.local_name|lower }}", remote_name=u"{{ attribute.remote_name }}", attribute_type={{ attribute.local_type }}, is_required={{ attribute.required }}, is_unique={{ attribute.unique }}{% if attribute.allowed_choices and attribute.allowed_choices|length > 0  %}, choices={{ attribute.allowed_choices|sort|trim }}{% endif %}){% endfor %}
        {% if specification.children_apis|length > 0 %}
        # Fetchers
        {% for api in specification.children_apis %}
        self.{{ api.instance_plural_name }} = {{ sdk_class_prefix }}{{ api.plural_name }}Fetcher.fetcher_with_object(parent_object=self)
        {% endfor %}{% endif %}

        self._compute_args(**kwargs)

    # Properties
    {% for attribute in specification.attributes %}
    def _get_{{ attribute.local_name }}(self):
        """ Get {{ attribute.local_name }} value.

            Notes:
                {{ attribute.description }}

                {% if attribute.local_name != attribute.remote_name %}
                This attribute is named `{{ attribute.remote_name }}` in {{ product_accronym }} API.
                {% endif %}
        """
        return self._{{ attribute.local_name }}

    def _set_{{ attribute.local_name }}(self, value):
        """ Set {{ attribute.local_name }} value.

            Notes:
                {{ attribute.description }}

                {% if attribute.local_name != attribute.remote_name %}
                This attribute is named `{{ attribute.remote_name }}` in {{ product_accronym }} API.
                {% endif %}
        """
        self._{{ attribute.local_name }} = value

    {{ attribute.local_name }} = property(_get_{{ attribute.local_name }}, _set_{{ attribute.local_name }})
    {% endfor %}
    # Methods

    @classmethod
    def is_resource_name_fixed(cls):
        """ Force resource name to True

            Returns:
                bool: always return True for {{ sdk_class_prefix }}{{ specification.name }} objects

        """

        return True

    def get_resource_url(self):
        """ Get the resource url for the given object.

            Notes:
                This method overrides bambou.NURESTObject method.

            Returns:
                string: a url with {{ sdk_class_prefix }}{{ specification.name }} specific resource name

            Example:
                >>> {{ specification.name }}.get_resource_url()
                https://.../nuage/api/v3_1/me
        """

        name = self.__class__.rest_resource_name
        url = self.__class__.rest_base_url()
        return "%s/%s" % (url, name)

    def get_resource_url_for_child_type(self, nurest_object_type):
        """ Get the resource url for {{ sdk_class_prefix }}{{ specification.name }}'s child objects.

            Notes:
                This method overrides bambou.NURESTObject method.

            Args:
                nurest_object_type (bambou.NURESTObject): type of child

            Returns:
                string: the url for the given object

            Example:
                >>> {{ specification.name }}.get_resource_url_for_child_type({{ sdk_class_prefix }}Enterprise)
                https://.../nuage/api/v3_1/enterprises
        """

        return "%s/%s" % (self.__class__.rest_base_url(), nurest_object_type.rest_resource_name)