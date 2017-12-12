--世界纪录仪 ～那孩子背负着太阳～
local m=33700190
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	Senya.AddSummonMusic(c,m*16+1,SUMMON_TYPE_SPECIAL)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetCondition(cm.slimit)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_MSET)
	e1:SetCondition(cm.slimit)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetFlagEffect(e:GetHandler():GetSummonPlayer(),m)==0
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.RegisterFlagEffect(e:GetHandler():GetSummonPlayer(),m,0,0,0)
	end)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(37564765,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		local tc=eg:GetFirst()
		return eg:GetCount()==1 and tc:IsType(TYPE_MONSTER) and tc:IsPreviousLocation(LOCATION_DECK) and tc:GetPreviousControler()==1-tp and (not tc:IsReason(REASON_DRAW) or tc:IsPublic())
	end)
	e3:SetTarget(cm.SelfSpsummonTarget)
	e3:SetOperation(cm.SelfSpsummonOperation)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.copytg)
	e2:SetOperation(cm.copyop)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(function(e)
		local c=e:GetHandler()
		return c:GetBaseAttack()==0 and c:GetBaseDefense()==0 and c:IsAttackAbove(0) and c:IsDefenseAbove(0)
	end)
	e4:SetValue(function(e,te)
		return te:GetOwner()~=e:GetOwner()
	end)
	c:RegisterEffect(e4)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(function(e)
		local c=e:GetHandler()
		return c:GetBaseAttack()==0 and c:GetBaseDefense()==0 and c:IsAttackAbove(0) and c:IsDefenseAbove(0)
	end)	
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function cm.slimit(e)
	return Duel.GetFlagEffect(tp,m)==0
end
function cm.Copy(c,tc)
	local atk=tc:GetTextAttack()
	local def=tc:GetTextDefense()
	local code=tc:GetOriginalCode()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetReset(0x1fe1000)
	e3:SetCode(EFFECT_SET_BASE_ATTACK)
	e3:SetValue(atk)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetReset(0x1fe1000)
	e4:SetCode(EFFECT_SET_BASE_DEFENSE)
	e4:SetValue(def)
	c:RegisterEffect(e4)
	local ccd=c:GetFlagEffectLabel(m)
	if ccd then
		c:ResetFlagEffect(m)
		c:ResetEffect(ccd,RESET_COPY)
	end
	local ecd=c:CopyEffect(code,RESET_EVENT+0x1fe0000,1)
	c:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,0,1,ecd)
end
function cm.SelfSpsummonTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and eg:GetFirst():IsType(TYPE_MONSTER) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.SelfSpsummonOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	if tc and e:GetHandler():IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		cm.Copy(c,code)
		Duel.SpecialSummonComplete()
	end
end
function cm.copyfilter(c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function cm.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.copyfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.copyfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and e:GetHandler():GetFlagEffect(m-700000)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.copyfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function cm.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsType(TYPE_TOKEN) and c:GetFlagEffect(m-700000)==0 then
		cm.Copy(c,tc)
		c:RegisterFlagEffect(m-700000,RESET_EVENT+0x1fe0000,0,10)
	end
end