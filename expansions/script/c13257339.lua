--里超时空战斗机-Hakurei Reimu
function c13257339.initial_effect(c)
	c:EnableCounterPermit(0x351)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13257339,3))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c13257339.addct)
	e1:SetOperation(c13257339.addc)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--Power Capsule
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13257339,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLED)
	e3:SetTarget(c13257339.pctg)
	e3:SetOperation(c13257339.pcop)
	c:RegisterEffect(e3)
	--bomb
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(13257339,6))
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetCost(c13257339.bombcost)
	e4:SetTarget(c13257339.bombtg)
	e4:SetOperation(c13257339.bombop)
	c:RegisterEffect(e4)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_SUMMON_SUCCESS)
	e11:SetOperation(c13257339.bgmop)
	c:RegisterEffect(e11)
	c13257339[c]=e3
	
end
function c13257339.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x351,1) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x351)
end
function c13257339.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x351,1)
	end
end
function c13257339.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local t1=e:GetHandler():IsCanAddCounter(0x351,1)
	if chk==0 then return true end
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(13257339,1))
	if t1 then
		op=Duel.SelectOption(tp,aux.Stringid(13257339,2),aux.Stringid(13257339,3))
	else
		op=Duel.SelectOption(tp,aux.Stringid(13257339,2))
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_ATKCHANGE)
	elseif op==1 then
		e:SetCategory(CATEGORY_COUNTER)
		Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x351)
	end
end
function c13257339.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(700)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			c:RegisterEffect(e1)
		end
	elseif e:GetLabel()==1 then
		if c:IsRelateToEffect(e) then
			c:AddCounter(0x351,1)
		end
	end
end
function c13257339.bombcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x351,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x351,1,REASON_COST)
end
function c13257339.rfilter(c)
	return ((c:IsFaceup() and c:IsLocation(LOCATION_EXTRA)) or c:IsLocation(LOCATION_GRAVE)) and c:IsAbleToRemove()
end
function c13257339.bombtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13257339.rfilter,tp,0,LOCATION_GRAVE+LOCATION_EXTRA,4,nil) end
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c13257339.efilter)
	e4:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
	e:GetHandler():RegisterEffect(e4)
end
function c13257339.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c13257339.bombop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c13257339.rfilter,tp,0,LOCATION_GRAVE+LOCATION_EXTRA,nil)
	local c=e:GetHandler()
	local d=math.floor(g:GetCount()/4)
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_UPDATE_ATTACK)
		e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e5:SetValue(700)
		c:RegisterEffect(e5)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=g:FilterSelect(tp,c13257339.rfilter,1,d,nil)
		if rg:GetCount()>0 then
			Duel.HintSelection(rg)
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		end
end
function c13257339.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(11,0,aux.Stringid(13257339,7))
end
