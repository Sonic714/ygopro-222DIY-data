--梦之公寓的圆盘人
function c71400004.initial_effect(c)
	--summon limit
	local el1=Effect.CreateEffect(c)
	el1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	el1:SetType(EFFECT_TYPE_SINGLE)
	el1:SetCode(EFFECT_CANNOT_SUMMON)
	el1:SetCondition(c71400004.sumlimit)
	c:RegisterEffect(el1)
	local el2=el1:Clone()
	el2:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(el2)
	local el3=el1:Clone()
	el3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(el3)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c71400004.condition1)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,71400004)
	e2:SetCondition(c71400004.condition2)
	e2:SetTarget(c71400004.target2)
	e2:SetOperation(c71400004.operation2)
	c:RegisterEffect(e2)
end
function c71400004.lfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3714) 
end
function c71400004.sumlimit(e)
	return not Duel.IsExistingMatchingCard(c71400004.lfilter,e:GetHandlerPlayer(),LOCATION_FZONE,0,1,nil)
end
function c71400004.filter1(c)
	return c:IsSetCard(0x714) and c:IsFaceup() and c:IsType(TYPE_TUNER)
end
function c71400004.condition1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
		and not c71400004.sumlimit(e)
		and Duel.IsExistingMatchingCard(c71400004.filter1,tp,LOCATION_MZONE,0,1,nil)
end
function c71400004.filter2(c)
	return c:IsSetCard(0xe714) and c:IsAbleToHand()
end
function c71400004.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c71400004.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400004.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c71400004.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c71400004.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end