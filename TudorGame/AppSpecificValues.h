//
//  AppSpecificValues.h
//  TudorGame
//
//  Created by David Joerg on 09.01.14.
//  Copyright (c) 2014 David Joerg. All rights reserved.
//

#ifndef TudorGame_AppSpecificValues_h
#define TudorGame_AppSpecificValues_h


#define LOGINVIEWCONTROLLER_ID @"login" 


//-----------------------------------------------------------------------------------------------------
#pragma Server
//-----------------------------------------------------------------------------------------------------
//Tudor: 10.14.1.83:8080

#define WEBSOCKET_ADDRESS @"ws://158.64.4.169:8080/TudorGameServer/game"
#define SERVERADDRESS @"http://158.64.4.169:8080"
#define REQUEST_CONNECT @"TudorGameServer/request/connectuser"
#define REQUEST_PRODUCTS @"TudorGameServer/request/getproducts"
#define REQUEST_QUICKGAME @"TudorGameServer/request/getquickgame"



//-----------------------------------------------------------------------------------------------------
#pragma Messages
//-----------------------------------------------------------------------------------------------------
#define GET_PRODUCTS @"GET_PRODUCTS"
#define GET_PRODUCT @"GET_PRODUCT"
#define GET_NEW_PRODUCT @"GET_NEW_PRODUCT"
#define GET_QUESTION @"GET_QUESTION"
#define USERDATA @"USERDATA"
#define GAMEDATA @"GAMEDATA"
#define PRODUCTS @"PRODUCTS"
#define PRODUCT @"PRODUCT"
#define QUESTION @"QUESTION"
#define GET_GAME @"GET_GAME"
#define QUIT_GAME @"QUIT_GAME"
#define START_GAME @"START_GAME"
#define GAME_STARTED @"GAME_STARTED"
#define MESSAGE_TYPE @"MESSAGE_TYPE"
#define PLAYER_ADDED @"PLAYER_ADDED"
#define PLAYER_READY @"PLAYER_READY"
#define PLAYER_IN_LOBBY @"PLAYER_IN_LOBBY"
#define ACTION_TYPE @"ACTION_TYPE"
#define GAME_ACTION @"GAME_ACTION"

//-----------------------------------------------------------------------------------------------------
#pragma Actions
//-----------------------------------------------------------------------------------------------------

#define FILLED_DECK @"FILLED_DECK"
#define NEXT_CARD @"NEXT_CARD"
#define MOVE_CARD @"MOVE_CARD"
#define TURN_CARD @"TURN_CARD"
#define ATTACK_CARD @"ATTACK_CARD"
#define ATTACK_OPPONENT @"ATTACK_OPPONENT"
#define SPELL_CARD @"SPELL_CARD"

//-----------------------------------------------------------------------------------------------------
#pragma Segues
//-----------------------------------------------------------------------------------------------------
#define SEGUE_QUICKGAME @"quickGameSegue"
#define SEGUE_SHOWDECK @"showDeckSegue"
#define SEGUE_PLAYER_CARDVIEW @"playerCardViewSegue"
#define SEGUE_OPPONENT_CARDVIEW @"opponentCardViewSegue"
#define SEGUE_GAMEVIEW @"gameViewSegue"
#define SEGUE_PRODUCT @"product"
#define SEGUE_PLAYER_FIELD @"playerFieldSegue"
#define SEGUE_OPPONENT_FIELD @"opponentFieldSegue"

//-----------------------------------------------------------------------------------------------------
#pragma LocalNotifications
//-----------------------------------------------------------------------------------------------------
#define DID_RECEIVE_REMOTE_NOTIFICATION @"UIApplicationDidReceiveRemoteNotification"
#define DID_CONNECT_TO_WEBSOCKET @"WebsocketDidOpen"
#define DID_RECEIVE_DATA_FROM_WEBSOCKET @"WebsocketReceivedData"
#define USER_STATUS_CHANGED @"UserStatusChanged"
#define PRODUCTS_UPDATED @"ProductsUpdated"
#define PRODUCT_RECEIVED @"ProductReceived"
#define QUESTION_RECEIVED @"QuestionReceived"
#define GAME_UPDATED @"GameUpdated"

//-----------------------------------------------------------------------------------------------------
#pragma APN
//-----------------------------------------------------------------------------------------------------
#define APN_DATA_TYPE_GAME_DATA @"GameData"

//-----------------------------------------------------------------------------------------------------
#pragma NutritiveIndices
//-----------------------------------------------------------------------------------------------------
#define K_JOULE @"EnergyKjoule"
#define KCAL @"EnergyKcal"
#define PROTEIN @"Protein"
#define CARBOHYDRATE @"Carbohydrate"
#define FAT @"Fat"
#define FIBRE @"Fibre"
#define SATURATES @"Saturates"
#define SUGAR @"Sugar"
#define SODIUM @"Sodium"


//-----------------------------------------------------------------------------------------------------
#pragma Status
//-----------------------------------------------------------------------------------------------------
#define USERNAME_OR_PASSWORD_WRONG @"USERNAME_OR_PASSWORD_WRONG"
#define  LOGIN_CORRECT @"LOGIN_CORRECT"
#define  USER_LOGGED_IN @"USER_LOGGED_IN"
#define REQUEST_FAILED @"REQUEST_FAILED"
#define USER_ALREADY_LOGGED_IN @"USER_ALREADY_LOGGED_IN"
#define USER_LOGGED_OUT @"USER_LOGGED_OUT"
#define USER_CONNECTION_FAIL @"USER_CONNECTION_FAIL"
#define CONNECTION_ESTABLISHED @"CONNECTION_ESTABLISHED"



//-----------------------------------------------------------------------------------------------------
#pragma GameStatus
//-----------------------------------------------------------------------------------------------------
#define GAMESTATUS_RUNNING @"RUNNING"
#define GAMESTATUS_WAITING_FOR_PLAYERS @"WAITINGFORPLAYERS"
#define GAMESTATUS_READY_TO_START @"READYTOSTART"



//-----------------------------------------------------------------------------------------------------
#pragma GameState
//-----------------------------------------------------------------------------------------------------
#define GAMESTATE_FIRST_ROUND @"FIRST_ROUND"
#define GAMESTATE_PHASE_ONE @"PHASE_ONE"
#define GAMESTATE_PHASE_TWO @"PHASE_TWO"
#define GAMESTATE_FINISHED @"PHASE_FINISHED"

//-----------------------------------------------------------------------------------------------------
#pragma SpellTypes
//-----------------------------------------------------------------------------------------------------
#define SPELLTYPE_DECREMENT_HP @"decrementHP"
#define SPELLTYPE_DECREMENT_ATK @"decrementATK"
#define SPELLTYPE_DECREMENT_DEF @"decrementDEF"
#define SPELLTYPE_INCREMENT_HP @"incrementHP"
#define SPELLTYPE_INCREMENT_ATK @"incrementATK"
#define SPELLTYPE_INCREMENT_DEF @"incrementDEF"

#define IS_IPHONE5          ([[UIScreen mainScreen] bounds].size.width >= 568 || [[UIScreen mainScreen] bounds].size.height >= 568)?YES:NO
#define IS_IPHONE           (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)?YES:NO
#define IS_IPAD             (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?YES:NO

#define DeviceType          ((IS_IPAD)?@"IPAD":(IS_IPHONE5)?@"IPHONE 5":@"IPHONE")


#endif

