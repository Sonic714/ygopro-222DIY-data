--妄想梦境-梦幻图书馆
function c71400014.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,71400014+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400014,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1)
	e2:SetCondition(c71400014.condition2)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(c71400014.target2)
	e2:SetOperation(c71400014.operation2)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71400014,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c71400014.condition3)
	e3:SetTarget(c71400014.target3)
	e3:SetOperation(c71400014.operation3)
	c:RegisterEffect(e3)
	--self limitation
	local esl=Effect.CreateEffect(c)
	esl:SetDescription(aux.Stringid(71400014,2))
	esl:SetType(EFFECT_TYPE_QUICK_F)
	esl:SetCode(EVENT_CHAINING)
	esl:SetRange(LOCATION_FZONE)
	esl:SetCondition(c71400014.slcon)
	esl:SetOperation(c71400014.slop)
	c:RegisterEffect(esl)
	--field activation
	local efa=Effect.CreateEffect(c)
	efa:SetDescription(aux.Stringid(71400014,4))
	efa:SetCategory(EFFECT_TYPE_ACTIVATE)
	efa:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	efa:SetCode(EVENT_LEAVE_FIELD)
	efa:SetRange(LOCATION_FZONE)
	efa:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	efa:SetCondition(c71400014.facon)
	efa:SetTarget(c71400014.fatg)
	efa:SetOperation(c71400014.faop)
	c:RegisterEffect(efa)
end
function c71400014.operation2(e,tp,eg,ep,ev,re,r,rp)
	local cnt=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if cnt<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then cnt=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c71400014.filter2,tp,LOCATION_HAND,0,1,cnt,nil,e,tp)
	if g:GetCount()==0 then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	local mg=Duel.GetMatchingGroup(c71400014.xyzfilter,tp,LOCATION_MZONE,0,nil)
	local xyzg=Duel.GetMatchingGroup(c71400014.xyz2filter,tp,LOCATION_EXTRA,0,nil,mg)
	if mg:GetCount()>0 and xyzg:GetCount()>0 and Duel.GetLocationCountFromEx(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(71400014,3)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,mg)
	end
end
function c71400014.filter2(c,e,tp)
	return c:IsSetCard(0x714) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71400014.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c71400014.filter2,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_HAND)
end
function c71400014.condition2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c71400014.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c71400014.xyzfilter,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(c71400014.xyz2filter,tp,LOCATION_EXTRA,0,1,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
--Select Xyz Materials
function c71400014.xyzfilter(c)
	return c:IsSetCard(0x714)
end
--Select Xyz Monsters
function c71400014.xyz2filter(c,mg)
	return c:IsSetCard(0x714) and c:IsXyzSummonable(mg)
end
function c71400014.condition3(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	return eg:GetCount()==1 and tg:IsSetCard(0x714) and tg:IsSummonType(SUMMON_TYPE_XYZ)
end
function c71400014.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function c71400014.operation3(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if dg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.HintSelection(g)
		Duel.SendtoGrave(g:GetFirst(),REASON_EFFECT)
	end
end
function c71400014.slcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==tp and not ec:IsSetCard(0x714)
end
function c71400014.slop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(c71400014.selflimit)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetValue(c71400014.selflimit)
	e2:SetTargetRange(1,0)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_MSET)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetValue(c71400014.selflimit)
	e3:SetTargetRange(1,0)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetReset(RESET_PHASE+PHASE_END)
	e4:SetValue(c71400014.selflimit)
	e4:SetTargetRange(1,0)
	Duel.RegisterEffect(e4,tp)
end
function c71400014.selflimit(e,re,tp)
	local c=re:GetHandler()
	return c:IsSetCard(0x714) and not c:IsImmuneToEffect(e)
end
function c71400014.fatg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400014.fafilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,tp) end
end
function c71400014.fafilter(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp) and c:IsSetCard(0xb714) and not c:IsCode(71400014)
end
function c71400014.facon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and not c:IsLocation(LOCATION_DECK)
		and c:IsPreviousPosition(POS_FACEUP)
end
function c71400014.faop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(71400014,5))
	local tc=Duel.SelectMatchingCard(tp,c71400014.fafilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,c71400014,te,0,tp,tp,Duel.GetCurrentChain())
	end
end