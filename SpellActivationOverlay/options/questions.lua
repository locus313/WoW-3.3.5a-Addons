local AddonName,SAO=...
local Module="questions"
SAO.QUESTIONS={
DISABLE_GAME_ALERT="disable_game_alert",
}
local questions={}
local function addQuestion(questionID,questionObject)
if not questions[questionID] then
questions[questionID]=questionObject
else
SAO:Error(Module, "Question with ID %s already exists",questionID)
end
end
addQuestion(SAO.QUESTIONS.DISABLE_GAME_ALERT,{
props={
displayGameSaoVar="displaySpellActivationOverlays",
staticPopupDialog="SAO_DISABLE_GAME_ALERT",
},
isPossible=function(self)
return SAO.IsProject(SAO.MOP_AND_ONWARD)
and C_CVar.GetCVarInfo(self.props.displayGameSaoVar)~=nil
end,
isRelevantNow=function(self)
return C_CVar.GetCVarBool(self.props.displayGameSaoVar)
and SpellActivationOverlayDB.alert.enabled
end,
mayAskAtStart=function(self)
return (
SpellActivationOverlayDB.questions.disableGameAlert==nil
or SpellActivationOverlayDB.questions.disableGameAlert=="yes" -- Ask again if the user already answered "yes"
)
end,
ask=function(self)
if not StaticPopupDialogs[self.props.staticPopupDialog] then
local displayGameSaoVar=self.props.displayGameSaoVar
local optionSequence=string.format(
"%s > %s > %s",
OPTIONS,
COMBAT_LABEL,
SPELL_ALERT_OPACITY
)
StaticPopupDialogs[self.props.staticPopupDialog]={
text="",
button1=YES,
button2=NO,
OnShow=function(self)
local textSetter=self.text or self
if self.data.answered=="yes" then
textSetter:SetText(SAO:spellAlertConflictsAgain())
else
textSetter:SetText(SAO:spellAlertConflicts())
end
end,
OnAccept=function(self)
SetCVar(displayGameSaoVar,false)
SpellActivationOverlayDB.questions.disableGameAlert="yes"
SpellActivationOverlayOptionsPanelSpellAlertAskDisableGameAlertButton:SetChecked(true)
SAO:Info(Module,SAO:gameSpellAlertsDisabled().."\n"..SAO:gameSpellAlertsChangeLater(optionSequence))
end,
OnCancel=function(self)
SpellActivationOverlayDB.questions.disableGameAlert="no"
SpellActivationOverlayOptionsPanelSpellAlertAskDisableGameAlertButton:SetChecked(false)
SAO:Info(Module,SAO:gameSpellAlertsLeftAsIs().."\n"..SAO:gameSpellAlertsChangeLater(optionSequence))
end,
whileDead=true,
customAlertIcon="Interface/Addons/SpellActivationOverlay/textures/rkm128",
hideOnEscape=true,
noCancelOnEscape=true,
timeout=0,
preferredindex=STATICPOPUP_NUMDIALOGS
}
end
StaticPopup_Show(self.props.staticPopupDialog,nil,nil,{answered=SpellActivationOverlayDB.questions.disableGameAlert})
end,
cancel=function(self)
if StaticPopupDialogs[self.props.staticPopupDialog] then
StaticPopup_Hide(self.props.staticPopupDialog)
end
end,
})
function SAO:IsQuestionPossible(questionID)
local question=questions[questionID]
if question then
return question:isPossible()
else
SAO:Error(Module, "Cannot check if question with ID %s is possible because it is unknown",tostring(questionID))
return false
end
end
function SAO:AskQuestion(questionID,askEvenIfIrrelevantNow)
if not SAO:GetDatabaseLoadingState().loaded then
SAO:Error(Module, "Cannot ask question with ID %s because the database is not loaded",tostring(questionID))
return
end
local question=questions[questionID]
if question then
if not question:isPossible()then
SAO:Warn(Module, "Question with ID %s should not be asked",tostring(questionID))
end
if askEvenIfIrrelevantNow or question:isRelevantNow()then
question:ask()
end
else
SAO:Error(Module, "Cannot ask a question with unknown ID %s",tostring(questionID))
end
end
function SAO:CancelQuestion(questionID)
local question=questions[questionID]
if question then
question:cancel()
else
SAO:Error(Module, "Cannot cancel a question with unknown ID %s",tostring(questionID))
end
end
function SAO:AskQuestionsAtStart()
if not SAO:GetDatabaseLoadingState().loaded then
SAO:Error(Module, "Cannot ask questions because the database is not loaded")
return
end
for _,question in pairs(questions)do
if question:isPossible() and question:isRelevantNow() and question:mayAskAtStart()then
question:ask()
end
end
end
