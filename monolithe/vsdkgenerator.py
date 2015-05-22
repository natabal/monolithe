#!/usr/bin/env python

import argparse
import sys

sys.path.append("../")


def main(argv=sys.argv):
    parser = argparse.ArgumentParser(description="Python SDK Generator.")

    parser.add_argument('-u', "--vsdurl",
                        dest="vsdurl",
                        help="URL of your VSD API where to get the get JSON information without version (ex: https://host:port/web/docs/api/)",
                        type=str)

    parser.add_argument('-v', "--apiversions",
                        dest="versions",
                        help="versions of the SDK to generate (examples: 1.0 3.0 3.1)",
                        nargs="*",
                        type=float)

    parser.add_argument('-f', "--file",
                        dest="swagger_path",
                        help="Path to a repository containing swagger api-docs file ",
                        type=str)

    parser.add_argument('-r', "--revision",
                        dest="revision",
                        help="Revision number of the SDK",
                        default=1,
                        type=int)

    parser.add_argument('-o', "--output",
                        dest='dest',
                        help="directory where the sources will be generated",
                        type=str)

    parser.add_argument("--force",
                        dest="force_removal",
                        help="Force removal of the existing generated code",
                        action="store_true")

    parser.add_argument('-s', "--specs",
                        dest='specifications_path',
                        help="Path to directory that contains .spec files",
                        type=str)

    args = parser.parse_args()

    from monolithe.generators import VSDKGenerator

    if args.versions:
        for version in args.versions:
            generator = VSDKGenerator(vsdurl=args.vsdurl, swagger_path=args.swagger_path, apiversion=version, output_path=args.dest, revision=args.revision, force_removal=args.force_removal, specifications_path=args.specifications_path)
            generator.run()
    else:
        generator = VSDKGenerator(vsdurl=args.vsdurl, swagger_path=args.swagger_path, apiversion=None, output_path=args.dest, revision=args.revision, force_removal=args.force_removal, specifications_path=args.specifications_path)
        generator.run()

if __name__ == '__main__':
    main()
