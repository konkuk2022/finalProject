import requests
from bs4 import BeautifulSoup
import json
import re



def spell_checker(sentence):

    _agent = requests.Session()

    url = "https://m.search.naver.com/p/csearch/ocontent/spellchecker.nhn"

    headers = {
        'User-Agent': "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36",
        'referer': 'https://search.naver.com/'
    }

    params = {
        '_callback': 'window.__jindo2_callback._spellingCheck_0',
        'q': sentence
    }
    

    page_source = _agent.get(url, headers=headers, params=params).text
    _dict = re.findall(r'(\{.+?\}+)', page_source)[0]
    data = json.loads(_dict)
    corrected = data["message"]["result"]["notag_html"]


    return corrected