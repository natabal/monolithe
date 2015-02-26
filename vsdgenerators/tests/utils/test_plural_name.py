# -*- coding: utf-8 -*-

from unittest import TestCase
from vsdgenerators.lib import Utils


class GetPluralNameTest(TestCase):
    """ Test for get_plural_name function

    """
    def assertPluralNameEquals(self, singular_name, plural_name):
        """ Check that the remote name is well converted to
            the python name

        """
        self.assertEqual(Utils.get_plural_name(singular_name), plural_name)

    def test_get_plural_name(self):
        """ Compute plural names properly

        """
        self.assertPluralNameEquals('enterprise', 'enterprises')
        self.assertPluralNameEquals('enterprises', 'enterprises')
        self.assertPluralNameEquals('Enterprise', 'Enterprises')
        self.assertPluralNameEquals('Enterprises', 'Enterprises')
        self.assertPluralNameEquals('policy', 'policies')
        self.assertPluralNameEquals('gateway', 'gateways')
        self.assertPluralNameEquals('Gateway', 'Gateways')
        self.assertPluralNameEquals('qos', 'qos')