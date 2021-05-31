"""
Copyright (c) 2020 Cisco and/or its affiliates.
This software is licensed to you under the terms of the Cisco Sample
Code License, Version 1.1 (the "License"). You may obtain a copy of the
License at
               https://developer.cisco.com/docs/licenses
All use of the material herein must be in accordance with the terms of
the License. All rights not expressly granted by the License are
reserved. Unless required by applicable law or agreed to separately in
writing, software distributed under the License is distributed on an "AS
IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
or implied.
"""

__author__ = "DevNet"
__version__ = "1.0.0"
__copyright__ = "Copyright (c) 2020 Cisco and/or its affiliates."
__license__ = "Cisco Sample Code License, Version 1.1"

import requests
import json
from config import token, productpage

base_url = "https://api.thousandeyes.com/v6/"

def create_test(test):
    headers = {"Authorization": token, "Content-Type": "application/json", "Accept": "application/json"}
    resp = requests.post(url='{}/tests/{}/new.json'.format(base_url, test["type"]), headers=headers, data=json.dumps(test))
    print(resp.status_code, test["type"], test["testName"])

def main():
    pageLoad  = {
        "agents": [{"agentId": 4503}, {"agentId": 4509}, {"agentId": 4577}, {"agentId": 47351}, {"agentId": 48608}],
 		"testName": "bookinfo-test-1",
		"type": "page-load",
		"interval": 300,
		"httpInterval": 300,
		"url": productpage
    }
    create_test(pageLoad)

    transactions = {
        "agents": [{"agentId": 4503}, {"agentId": 4509}, {"agentId": 4577}, {"agentId": 47351}, {"agentId": 48608}],
 		"testName": "bookinfo-test-2",
		"type": "web-transactions",
		"interval": 300,
		"httpInterval": 300,
		"url": productpage,
        "transactionScript": open("script.js", "r").read()
    }
    create_test(transactions)


if __name__ == '__main__':
    main()
