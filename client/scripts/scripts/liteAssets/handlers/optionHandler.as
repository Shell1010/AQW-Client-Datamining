package liteAssets.handlers
{
   import flash.display.*;
   import flash.events.*;
   import flash.media.*;
   import flash.net.*;
   import flash.system.*;
   import flash.ui.*;
   import flash.utils.*;
   import liteAssets.draw.*;
   import liteAssets.mobile.*;

   public class optionHandler extends MovieClip
   {

      public function optionHandler()
      {
         super();
      }

      public static function key(param1:MovieClip, param2:String, param3:uint) : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         param1.litePreference.data.keys[param2] = param3;
         if(param2.indexOf("Auto Attack") > -1 || param2.indexOf("Skill ") > -1)
         {
            _loc1_ = !param3 ? " " : param1.keyDict[param3];
            if(param2 == "Auto Attack")
            {
               param1.ui.mcInterface.getChildByName("keyA0").text = _loc1_;
            }
            else
            {
               _loc2_ = param2.split(" ")[1];
               param1.ui.mcInterface.getChildByName("keyA" + _loc2_).text = _loc1_;
            }
         }
      }

      public static function cmd(param1:MovieClip, param2:String) : void
      {
         var mDrops:* = undefined;
         var csOn:Boolean = false;
         var posKey:String = null;
         var player:* = undefined;
         var csPlayer:* = undefined;
         var csMon:* = undefined;
         var mons:* = undefined;
         var monChar:MovieClip = null;
         var i:int = 0;
         var j:int = 0;
         var mcDrop:* = undefined;
         var _m:* = undefined;
         var blacklist:blackList = null;
         var travelMenuMC:travelMenu = null;
         var r:MovieClip = param1;
         var id:String = param2;
         switch(id)
         {
            case "@ Debugger":
               r.litePreference.data.bDebugger = !r.litePreference.data.bDebugger;
               r.litePreference.flush();
               if(r.litePreference.data.bDebugger)
               {
                  r.cMenuUI = new cellMenu(r);
                  if(r.litePreference.data.dOptions["debugPacket"])
                  {
                     r.pLoggerUI = new packetlogger(r);
                  }
                  else if(r.pLoggerUI != null)
                  {
                     r.pLoggerUI.cleanup();
                  }
               }
               else
               {
                  if(r.cMenuUI != null)
                  {
                     r.cMenuUI.cleanup();
                  }
                  if(r.pLoggerUI != null)
                  {
                     r.pLoggerUI.cleanup();
                  }
               }
               break;
            case "Disable Linkage Errors":
               r.litePreference.data.dOptions["debugLinkage"] = !r.litePreference.data.dOptions["debugLinkage"];
               r.litePreference.flush();
               break;
            case "Disable Color Coded Items":
               r.litePreference.data.dOptions["debugColor"] = !r.litePreference.data.dOptions["debugColor"];
               r.litePreference.flush();
               break;
            case "Packet Logger":
               r.litePreference.data.dOptions["debugPacket"] = !r.litePreference.data.dOptions["debugPacket"];
               r.litePreference.flush();
               if(r.litePreference.data.bDebugger)
               {
                  if(r.litePreference.data.dOptions["debugPacket"])
                  {
                     r.pLoggerUI = new packetlogger(r);
                  }
                  else if(r.pLoggerUI != null)
                  {
                     r.pLoggerUI.cleanup();
                  }
               }
               else if(r.pLoggerUI != null)
               {
                  r.pLoggerUI.cleanup();
               }
               break;
            case "Allow Quest Log Turn-Ins":
               r.litePreference.data.bQuestLog = !r.litePreference.data.bQuestLog;
               r.litePreference.flush();
               break;
            case "Auto-Untarget Dead Targets":
               r.litePreference.data.bUntargetDead = !r.litePreference.data.bUntargetDead;
               r.litePreference.flush();
               if(r.litePreference.data.bUntargetDead)
               {
                  if(r.world.myAvatar.target != null && r.world.myAvatar.target.dataLeaf.intState == 0)
                  {
                     r.world.cancelTarget();
                  }
               }
               break;
            case "Auto-Untarget Self":
               r.litePreference.data.bUntargetSelf = !r.litePreference.data.bUntargetSelf;
               r.litePreference.flush();
               if(r.litePreference.data.bUntargetSelf)
               {
                  if(r.world.myAvatar.target != null && Boolean(r.world.myAvatar.target.isMyAvatar))
                  {
                     r.world.cancelTarget();
                  }
               }
               break;
            case "Reset UI Positions":
               for each(posKey in ["posAurasP","posAurasT","posParty","posMonDrops"])
               {
                  r.litePreference.data[posKey] = null;
               }
               r.litePreference.flush();
               if(r.pAurasUI != null)
               {
                  r.pAurasUI.resetPosition();
               }
               if(r.tAurasUI != null)
               {
                  r.tAurasUI.resetPosition();
               }
               if(r.partyDrag != null)
               {
                  r.partyDrag.reset(10,110.85);
               }
               r.organizeBoostIcons();
               mDrops = r.ui.getChildByName("monsterDropsPanel");
               if(mDrops is monsterDrops)
               {
                  monsterDrops(mDrops).resetPosition();
               }
               break;
            case "Battle Analyzer":
               if(r.ui.getChildByName("battleAnalyzer"))
               {
                  return;
               }
               r.bAnalyzer = new battleAnalyzer();
               r.ui.addChild(r.bAnalyzer);
               r.bAnalyzer.name = "battleAnalyzer";
               break;
            case "Battlepets":
               r.litePreference.data.bBattlepet = !r.litePreference.data.bBattlepet;
               r.litePreference.flush();
               break;
            case "Static Player Art":
               r.litePreference.data.bCachePlayers = !r.litePreference.data.bCachePlayers;
               r.litePreference.flush();
               for each(player in r.world.avatars)
               {
                  if(player.pMC)
                  {
                     if(!player.isMyAvatar)
                     {
                        try
                        {
                           if(r.litePreference.data.bCachePlayers)
                           {
                              player.pMC.rasterizeChar();
                           }
                           else
                           {
                              player.pMC.derasterizeChar();
                              player.pMC.mcChar.gotoAndPlay("Idle");
                           }
                        }
                        catch(exception:*)
                        {
                           continue;
                        }
                     }
                  }
               }
               break;
            case "Character Select Screen":
               r.litePreference.data.bCharSelect = !r.litePreference.data.bCharSelect;
               r.litePreference.flush();
               if(r.litePreference.data.bCharSelect)
               {
                  r.saveChar();
               }
               break;
            case "Comic Sans Font":
               r.litePreference.data.bComicSans = !r.litePreference.data.bComicSans;
               r.litePreference.flush();
               csOn = Boolean(r.litePreference.data.bComicSans);
               for each(csPlayer in r.world.avatars)
               {
                  if(csPlayer.pMC)
                  {
                     r.applyComicSansPname(csPlayer.pMC.pname,csOn);
                  }
               }
               for each(csMon in r.world.monsters)
               {
                  if(csMon.pMC)
                  {
                     r.applyComicSansPname(csMon.pMC.pname,csOn);
                  }
               }
               break;
            case "Chat Settings":
               r.litePreference.data.bChatFilter = !r.litePreference.data.bChatFilter;
               r.litePreference.flush();
               break;
            case "Vanishing Messages":
               r.litePreference.data.dOptions["vanishMsg"] = !r.litePreference.data.dOptions["vanishMsg"];
               r.litePreference.flush();
               break;
            case "Timestamps":
               r.litePreference.data.dOptions["timeStamps"] = !r.litePreference.data.dOptions["timeStamps"];
               r.litePreference.flush();
               break;
            case "Disable Blue Messages":
               r.litePreference.data.dOptions["disBlue"] = !r.litePreference.data.dOptions["disBlue"];
               r.litePreference.flush();
               break;
            case "Disable Red Messages":
               r.litePreference.data.dOptions["disRed"] = !r.litePreference.data.dOptions["disRed"];
               r.litePreference.flush();
               break;
            case "Chat UI":
               r.litePreference.data.bChatUI = !r.litePreference.data.bChatUI;
               r.litePreference.flush();
               break;
            case "Minimal Mode":
               r.litePreference.data.dOptions["chatMinimal"] = !r.litePreference.data.dOptions["chatMinimal"];
               r.litePreference.flush();
               if(r.intChatMode)
               {
                  r.chatF.setMinimalMode(r.litePreference.data.dOptions["chatMinimal"]);
               }
               break;
            case "Disable AutoScroll to Bottom":
               r.litePreference.data.dOptions["chatScroll"] = !r.litePreference.data.dOptions["chatScroll"];
               r.litePreference.flush();
               break;
            case "Class Actives/Auras UI":
               r.litePreference.data.bAuras = !r.litePreference.data.bAuras;
               r.litePreference.flush();
               if(r.pAurasUI != null)
               {
                  r.pAurasUI.cleanup();
               }
               if(r.tAurasUI != null)
               {
                  r.tAurasUI.cleanup();
               }
               r.pAurasUI = null;
               r.tAurasUI = null;
               if(r.litePreference.data.bAuras)
               {
                  r.pAurasUI = new playerAuras(r);
                  r.tAurasUI = new targetAuras(r);
               }
               break;
            case "Disable ToolTips":
               r.litePreference.data.dOptions["disAuraTips"] = !r.litePreference.data.dOptions["disAuraTips"];
               r.litePreference.flush();
               break;
            case "Disable Aura Text":
               r.litePreference.data.dOptions["disAuraText"] = !r.litePreference.data.dOptions["disAuraText"];
               r.litePreference.flush();
               break;
            case "Color Sets":
               r.litePreference.data.bColorSets = !r.litePreference.data.bColorSets;
               r.litePreference.flush();
               break;
            case "Custom Drops UI":
               r.litePreference.data.bCustomDrops = !r.litePreference.data.bCustomDrops;
               r.litePreference.flush();
               if(r.litePreference.data.bCustomDrops)
               {
                  r.cDropsUI = new customDrops(r);
               }
               else if(r.cDropsUI != null)
               {
                  r.cDropsUI.cleanup();
               }
               break;
            case "Classic Drops on Mobile":
               r.litePreference.data.dOptions["classicDropsMobile"] = r.litePreference.data.dOptions["classicDropsMobile"] != true;
               r.litePreference.flush();
               if(r.cDropsUI != null)
               {
                  r.cDropsUI.refreshMode();
               }
               if(r.litePreference.data.dOptions["classicDropsMobile"] == true)
               {
                  LootFeed.clear();
               }
               break;
            case "Mobile Loot Notifications":
               r.litePreference.data.dOptions["lootFeedOff"] = r.litePreference.data.dOptions["lootFeedOff"] != true;
               r.litePreference.flush();
               if(r.litePreference.data.dOptions["lootFeedOff"] == true)
               {
                  LootFeed.clear();
               }
               break;
            case "Invert Menu":
               r.litePreference.data.dOptions["invertMenu"] = !r.litePreference.data.dOptions["invertMenu"];
               r.litePreference.flush();
               break;
            case "Warn When Declining A Drop":
               r.litePreference.data.dOptions["warnDecline"] = !r.litePreference.data.dOptions["warnDecline"];
               r.litePreference.flush();
               break;
            case "Hide Drop Notifications":
               r.litePreference.data.dOptions["hideDrop"] = !r.litePreference.data.dOptions["hideDrop"];
               r.litePreference.flush();
               break;
            case "Hide Temporary Drop Notifications":
               r.litePreference.data.dOptions["hideTemp"] = !r.litePreference.data.dOptions["hideTemp"];
               r.litePreference.flush();
               break;
            case "Opened Menu":
               r.litePreference.data.dOptions["openMenu"] = !r.litePreference.data.dOptions["openMenu"];
               r.litePreference.flush();
               break;
            case "Draggable Mode":
               r.litePreference.data.dOptions["dragMode"] = !r.litePreference.data.dOptions["dragMode"];
               r.litePreference.flush();
               if(r.cDropsUI)
               {
                  r.cDropsUI.onChange(r.litePreference.data.dOptions["dragMode"]);
               }
               break;
            case "Lock Position":
               r.litePreference.data.dOptions["lockMode"] = !r.litePreference.data.dOptions["lockMode"];
               r.litePreference.flush();
               if(r.cDropsUI)
               {
                  r.cDropsUI.lockMode();
               }
               break;
            case "Reset Position":
               if(r.cDropsUI)
               {
                  r.cDropsUI.resetPos();
               }
               break;
            case "Quantity Warnings":
               r.litePreference.data.dOptions["termsAgree"] = !r.litePreference.data.dOptions["termsAgree"];
               r.litePreference.flush();
               break;
            case "Disable Chat Scrolling":
               r.litePreference.data.bDisChatScroll = !r.litePreference.data.bDisChatScroll;
               r.litePreference.flush();
               break;
            case "Disable Damage Numbers":
               r.litePreference.data.bDisDmgDisplay = !r.litePreference.data.bDisDmgDisplay;
               r.litePreference.flush();
               break;
            case "Disable Damage Strobe":
               r.litePreference.data.bDisDmgStrobe = !r.litePreference.data.bDisDmgStrobe;
               r.litePreference.flush();
               break;
            case "Disable Monster Animations":
               r.litePreference.data.bDisMonAnim = !r.litePreference.data.bDisMonAnim;
               r.litePreference.flush();
               for(mons in r.world.monsters)
               {
                  if(r.world.monsters[mons].dataLeaf)
                  {
                     if(r.world.monsters[mons].pMC)
                     {
                        monChar = r.world.monsters[mons].pMC.getChildAt(1) as MovieClip;
                        if(monChar != null)
                        {
                           monChar.cacheAsBitmap = r.litePreference.data.bDisMonAnim;
                           if(r.litePreference.data.bDisMonAnim)
                           {
                              r.movieClipStopAll(monChar);
                           }
                        }
                     }
                  }
               }
               break;
            case "Disable Self Animations":
               r.litePreference.data.bDisSelfMAnim = !r.litePreference.data.bDisSelfMAnim;
               r.litePreference.flush();
               break;
            case "Disable Skill Animations":
               r.litePreference.data.bDisSkillAnim = !r.litePreference.data.bDisSkillAnim;
               r.litePreference.flush();
               break;
            case "Show Your Skill Animations Only":
               r.litePreference.data.dOptions["animSelf"] = !r.litePreference.data.dOptions["animSelf"];
               r.litePreference.flush();
               break;
            case "Disable Sound FX":
               r.litePreference.data.bDisSoundFX = !r.litePreference.data.bDisSoundFX;
               r.litePreference.flush();
               r.mixer.stf = r.litePreference.data.bDisSoundFX ? new SoundTransform(0) : new SoundTransform(1);
               break;
            case "Disable Quest Popup":
               r.litePreference.data.bDisQPopup = !r.litePreference.data.bDisQPopup;
               r.litePreference.flush();
               break;
            case "Disable Quest Tracker":
               r.litePreference.data.bDisQTracker = !r.litePreference.data.bDisQTracker;
               r.litePreference.flush();
               break;
            case "Disable Weapon Animations":
               r.litePreference.data.bDisWepAnim = !r.litePreference.data.bDisWepAnim;
               r.litePreference.flush();
               if(r.litePreference.data.bDisWepAnim)
               {
                  for each(player in r.world.avatars)
                  {
                     if(player.objData)
                     {
                        if(player.pMC)
                        {
                           try
                           {
                              player.pMC.mcChar.weapon.mcWeapon.gotoAndStop(0);
                              (player.pMC.mcChar.weaponOff.getChildAt(0) as MovieClip).gotoAndStop(0);
                              r.movieClipStopAll(player.pMC.mcChar.weapon.mcWeapon);
                              r.movieClipStopAll(player.pMC.mcChar.weaponOff.getChildAt(0) as MovieClip);
                           }
                           catch(exception:*)
                           {
                           }
                           continue;
                        }
                     }
                  }
               }
               break;
            case "Keep Your Weapon Animations Only":
               r.litePreference.data.dOptions["wepSelf"] = !r.litePreference.data.dOptions["wepSelf"];
               r.litePreference.flush();
               break;
            case "Decline All Drops":
               if(r.litePreference.data.bCustomDrops)
               {
                  r.cDropsUI.onUpdate();
               }
               else
               {
                  i = 0;
                  while(i < r.ui.dropStack.numChildren)
                  {
                     try
                     {
                        r.ui.dropStack.getChildAt(i).cnt.nbtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                     }
                     catch(e:*)
                     {
                     }
                     i++;
                  }
               }
               break;
            case "Display FPS":
               r.ui.mcFPS.visible = !r.ui.mcFPS.visible;
               break;
            case "Draggable Drops":
               r.litePreference.data.bDraggable = !r.litePreference.data.bDraggable;
               r.litePreference.flush();
               if(r.ui.dropStack.numChildren < 1)
               {
                  break;
               }
               j = 0;
               while(j < r.ui.dropStack.numChildren)
               {
                  try
                  {
                     mcDrop = r.ui.dropStack.getChildAt(i);
                     if(mcDrop.hasEventListener(MouseEvent.MOUSE_DOWN))
                     {
                        mcDrop.addEventListener(MouseEvent.MOUSE_DOWN,dStartDrag,false,0,true);
                        mcDrop.addEventListener(MouseEvent.MOUSE_UP,dStopDrag,false,0,true);
                     }
                  }
                  catch(exception:*)
                  {
                     trace("[UI] ERR handling drops: " + exception);
                  }
                  j++;
               }
               break;
            case "Freeze / Lock Monster Position":
               r.litePreference.data.bFreezeMons = !r.litePreference.data.bFreezeMons;
               r.litePreference.flush();
               for each(_m in r.world.monsters)
               {
                  if(_m)
                  {
                     if(_m.pMC)
                     {
                        if(_m.pMC.getChildAt(1))
                        {
                           _m.pMC.noMove = r.litePreference.data.bFreezeMons;
                           if(_m.pMC.noMove)
                           {
                              _m.pMC.stopWalking();
                           }
                        }
                     }
                  }
               }
               break;
            case "Invisible Monsters":
               r.litePreference.data.bHideMons = !r.litePreference.data.bHideMons;
               r.litePreference.flush();
               for each(_m in r.world.monsters)
               {
                  if(_m)
                  {
                     if(_m.pMC)
                     {
                        if(_m.pMC.getChildAt(1))
                        {
                           _m.pMC.getChildAt(1).visible = !r.litePreference.data.bHideMons;
                        }
                     }
                  }
               }
               break;
            case "Hide Players":
               r.litePreference.data.bHidePlayers = !r.litePreference.data.bHidePlayers;
               r.litePreference.flush();
               for each(player in r.world.avatars)
               {
                  if(Boolean(player.pMC) && !player.isMyAvatar)
                  {
                     player.pMC.mcChar.visible = !r.litePreference.data.bHidePlayers;
                     player.pMC.pname.visible = r.litePreference.data.dOptions["showNames"];
                     player.pMC.shadow.visible = r.litePreference.data.dOptions["showShadows"];
                     if(!r.litePreference.data.bHidePlayers)
                     {
                        player.pMC.pname.visible = true;
                        player.pMC.shadow.visible = true;
                        if(player.getItemByEquipSlot("mi"))
                        {
                           player.pMC.cShadow.visible = !r.litePreference.data.bDisGround;
                        }
                     }
                     else
                     {
                        player.pMC.cShadow.visible = false;
                     }
                  }
               }
               break;
            case "Show Name Tags":
               r.litePreference.data.dOptions["showNames"] = !r.litePreference.data.dOptions["showNames"];
               r.litePreference.flush();
               break;
            case "Show Shadows":
               r.litePreference.data.dOptions["showShadows"] = !r.litePreference.data.dOptions["showShadows"];
               r.litePreference.flush();
               break;
            case "Hide Player Names":
               r.litePreference.data.bHideNames = !r.litePreference.data.bHideNames;
               r.litePreference.flush();
               for each(player in r.world.avatars)
               {
                  if(player.pMC)
                  {
                     if(!r.litePreference.data.bHideNames)
                     {
                        player.pMC.hideNameCleanup();
                     }
                     else
                     {
                        player.pMC.hideNameSetup();
                     }
                  }
               }
               break;
            case "Hide Guild Names Only":
               r.litePreference.data.dOptions["hideGuild"] = !r.litePreference.data.dOptions["hideGuild"];
               r.litePreference.flush();
               if(r.litePreference.data.bHideNames)
               {
                  for each(player in r.world.avatars)
                  {
                     if(player.pMC)
                     {
                        player.pMC.hideNameSetup();
                     }
                  }
               }
               break;
            case "Hide Your Name Only":
               r.litePreference.data.dOptions["hideSelf"] = !r.litePreference.data.dOptions["hideSelf"];
               r.litePreference.flush();
               if(r.litePreference.data.bHideNames)
               {
                  for each(player in r.world.avatars)
                  {
                     if(player.pMC)
                     {
                        player.pMC.hideNameSetup();
                     }
                  }
               }
               break;
            case "Hide UI":
               r.litePreference.data.bHideUI = !r.litePreference.data.bHideUI;
               r.litePreference.flush();
               if(r.mailHub != null)
               {
                  r.mailHub.applyUIHidden();
               }
               if(r.litePreference.data.bHideUI)
               {
                  r.ui.mcInterface.areaList.visible = false;
                  r.hidePortrait();
                  r.hidePortraitTarget();
               }
               else
               {
                  r.world.setTarget(null);
                  r.ui.mcInterface.areaList.visible = true;
                  r.showPortrait(r.world.myAvatar);
                  if(r.world.myAvatar.target)
                  {
                     r.showPortraitTarget(r.world.myAvatar.target);
                  }
               }
               break;
            case "Item Drops Block List":
               if(!r.ui.getChildByName("mcBlacklist"))
               {
                  blacklist = new blackList(r);
                  blacklist.name = "mcBlacklist";
                  r.ui.addChild(blacklist);
               }
               break;
            case "Gamepad Controls":
               GamepadPanel.open(r);
               break;
            case "Keybinds":
               KeybindsPanel.open(r);
               break;
            case "Reaccept Quest After Turn-In":
               r.litePreference.data.bReaccept = !r.litePreference.data.bReaccept;
               r.litePreference.flush();
               break;
            case "Show Monster Type":
               r.litePreference.data.bMonsType = !r.litePreference.data.bMonsType;
               r.litePreference.flush();
               break;
            case "Smooth Background":
               r.litePreference.data.bSmoothBG = !r.litePreference.data.bSmoothBG;
               r.litePreference.flush();
               try
               {
                  if(r.world != null)
                  {
                     r.world.applySmoothBG();
                  }
               }
               catch(exception:*)
               {
               }
               break;
            case "Travel Menu":
               if(!r.ui.getChildByName("mcTravelMenu"))
               {
                  travelMenuMC = new travelMenu(r);
                  travelMenuMC.name = "mcTravelMenu";
                  r.ui.addChild(travelMenuMC);
               }
               break;
            case "Quest Pinner":
               r.litePreference.data.bQuestPin = !r.litePreference.data.bQuestPin;
               r.litePreference.flush();
               break;
            case "Quest Progress Notifications":
               r.litePreference.data.bQuestNotif = !r.litePreference.data.bQuestNotif;
               r.litePreference.flush();
               break;
            case "Visual Skill CDs":
               r.litePreference.data.bSkillCD = !r.litePreference.data.bSkillCD;
               r.litePreference.flush();
               break;
            case "Hide Ground Items":
               r.litePreference.data.bDisGround = !r.litePreference.data.bDisGround;
               r.litePreference.flush();
               if(r.litePreference.data.bDisGround)
               {
                  for each(player in r.world.avatars)
                  {
                     if(!(Boolean(player.isMyAvatar) && Boolean(r.litePreference.data.dOptions["groundSelf"])))
                     {
                        if(Boolean(player.pMC) && Boolean(player.getItemByEquipSlot("mi")))
                        {
                           MovieClip(player.pMC).cShadow.visible = false;
                           MovieClip(player.pMC).shadow.alpha = 1;
                        }
                     }
                  }
               }
               else
               {
                  for each(player in r.world.avatars)
                  {
                     if(!(Boolean(player.isMyAvatar) && Boolean(r.litePreference.data.dOptions["groundSelf"])))
                     {
                        if(Boolean(player.pMC) && Boolean(player.getItemByEquipSlot("mi")))
                        {
                           MovieClip(player.pMC).cShadow.visible = player.isMyAvatar || !r.litePreference.data.bHidePlayers;
                           MovieClip(player.pMC).shadow.alpha = 0;
                        }
                     }
                  }
               }
               break;
            case "Show Your Ground Item Only":
               r.litePreference.data.dOptions["groundSelf"] = !r.litePreference.data.dOptions["groundSelf"];
               r.litePreference.flush();
               if(r.litePreference.data.bDisGround)
               {
                  if(r.world.myAvatar.pMC)
                  {
                     MovieClip(r.world.myAvatar.pMC).cShadow.visible = true;
                     MovieClip(r.world.myAvatar.pMC).shadow.alpha = 0;
                  }
               }
               else if(r.world.myAvatar.pMC)
               {
                  MovieClip(r.world.myAvatar.pMC).cShadow.visible = false;
                  MovieClip(r.world.myAvatar.pMC).shadow.alpha = 1;
               }
               break;
            case "Hide Healing Bubbles":
               r.litePreference.data.bDisHealBubble = !r.litePreference.data.bDisHealBubble;
               r.litePreference.flush();
               break;
            case "Disable Aura Animations":
               r.litePreference.data.bDisAuraAnim = !r.litePreference.data.bDisAuraAnim;
               r.litePreference.flush();
               break;
            case "Show Your Aura Animation Only":
               r.litePreference.data.dOptions["auraAnimSelf"] = !r.litePreference.data.dOptions["auraAnimSelf"];
               r.litePreference.flush();
         }
      }

      private static function dStartDrag(param1:MouseEvent) : void
      {
         param1.currentTarget.startDrag();
      }

      private static function dStopDrag(param1:MouseEvent) : void
      {
         param1.currentTarget.stopDrag();
      }
   }
}
