//
//  BighornStats.swift
//  PITPal
//
//  Created by Doug Haacke on 6/15/25.
//

struct BighornStats: Codable, Identifiable {
    let id:         Int
    let label:      String
    let value:      Double
    let suffix:     String
    let decimals:   Int
}

/*
 
 [{
   "id": 1,
   "label": "River",
   "value": 2854.48,
   "suffix": "cfs",
   "decimals": 0
 }, {
   "id": 2,
   "label": "Feels like",
   "value": 5015.73,
   "suffix": "cfs",
   "decimals": 0
 }, {
   "id": 3,
   "label": "Afterbay",
   "value": 65.3,
   "suffix": "°",
   "decimals": 1
 }, {
   "id": 4,
   "label": "St. X",
   "value": 62.6,
   "suffix": "°",
   "decimals": 1
 }, {
   "id": 5,
   "label": "Shift",
   "value": -1.59,
   "suffix": "in",
   "decimals": 1
 }, {
   "id": 6,
   "label": "PSAT",
   "value": 107.07,
   "suffix": "%",
   "decimals": 1
 }, {
   "id": 7,
   "label": "Lake elev",
   "value": 3638.17,
   "suffix": "ft",
   "decimals": 0
 }, {
   "id": 8,
   "label": "Inflows",
   "value": 3110.03,
   "suffix": "cfs",
   "decimals": 0
 }, {
   "id": 9,
   "label": "Canal",
   "value": 0,
   "suffix": "cfs",
   "decimals": 0
 }, {
   "id": 10,
   "label": "Spillway",
   "value": 0,
   "suffix": "cfs",
   "decimals": 0
 }, {
   "id": 11,
   "label": "Turbines",
   "value": 2787.36,
   "suffix": "cfs",
   "decimals": 0
 }, {
   "id": 12,
   "label": "SWE",
   "value": 0,
   "suffix": "in",
   "decimals": 1
 }]
 
*/
