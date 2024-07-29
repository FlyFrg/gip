{
  "input": [
    {
      "type": "text",
      "action": "add",
      "args": {
        "name": "tm",
        "uri": "./manual/tm.txt"
      }
    }
    ,{"type":"private","action":"add"}
  ],
  "output": [
    {
      "type": "v2rayGeoIPDat",
      "action": "output",
      "args": {
        "outputName": "geoip-tm.dat",
        "wantedList": ["tm","private"]
      }
    },
    {
      "type": "text",
      "action": "output"
    }
  ]
}
