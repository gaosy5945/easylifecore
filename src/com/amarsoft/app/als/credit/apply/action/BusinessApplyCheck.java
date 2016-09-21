package com.amarsoft.app.als.credit.apply.action;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.als.awe.script.WebBusinessProcessor;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.ObjectWindowHelper;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.Arith;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.json.JSONObject;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Item;

public class BusinessApplyCheck extends WebBusinessProcessor {
	public String checkRPT(JBOTransaction tx) throws Exception{
		BusinessObject inputObject = this.getInputParameters();
		int businessTermMonth=inputObject.getInt("BusinessTerm");
		List<String> resultInfo=new ArrayList<String>();
		JSONObject rptdata = (JSONObject)this.inputParameter.getValue("rptdata");
		List<BusinessObject> businessObjectArray = new ArrayList<BusinessObject>();
		boolean existsFixPrincipal=false;
		boolean existsOther=false;
		double businessBalance = inputObject.getDouble("BusinessSum");
		String paymentFrequencyType = inputObject.getString("PayFrequencyType");
		String defaultDueDay = inputObject.getString("DefaultDueDay");
		int paymentFrequencyTerm = inputObject.getInt("PayFrequency");
		String objectType = inputObject.getString("ObjectType");
		String objectNo = inputObject.getString("ObjectNo");
		int dueTerm = 0;//�ѻ��ڴ�
		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(tx);
		if("jbo.acct.ACCT_LOAN_CHANGE".equals(objectType)){
			BusinessObject loanchange = bom.keyLoadBusinessObject(objectType, objectNo);
			String relativeObjectType = loanchange.getString("ObjectType");
			String relativeObjectNo = loanchange.getString("ObjectNo");
			BusinessObject businessobject = bom.keyLoadBusinessObject(relativeObjectType, relativeObjectNo);
			businessBalance = businessobject.getDouble("Balance");
			
			Transaction sqlca = Transaction.createTransaction(tx);
			SqlObject asql = new SqlObject("select max(SeqID) from acct_payment_schedule where duebillno=:DueBillNo and Status='L2' ")
				.setParameter("DueBillNo", relativeObjectNo);
			ASResultSet rs = sqlca.getASResultSet(asql);
			if(rs.next()){
				dueTerm = rs.getInt(1);
			}
			rs.close();
		}
		
		
		if(!"99".equals(paymentFrequencyType))
		{
			Item item = CodeCache.getItem("PaymentFrequencyType", paymentFrequencyType);
			if(item != null)
			{
				paymentFrequencyTerm = DataConvert.toInt(item.getRelativeCode());
			}
		}
		
		if(paymentFrequencyTerm <= 0) paymentFrequencyTerm = 1;
		
		Map<Integer,BusinessObject> segMap=new HashMap<Integer,BusinessObject>();
		
		int lastsegtostage=0;
		if("jbo.acct.ACCT_LOAN_CHANGE".equals(objectType)){
			lastsegtostage = dueTerm;
		}
		
		for(int i=0;i<rptdata.size();i++){
			JSONObject data = (JSONObject)rptdata.get(i).getValue();
			int rowNum = (Integer)data.getValue("RowNum")+1;
			BusinessObject rptObject = ObjectWindowHelper.createBusinessObject_JSON(data);
			businessObjectArray.add(rptObject);
			int segtostage = rptObject.getInt("SEGTOSTAGE");
			if(segtostage<=0){
				resultInfo.add("����ϻ��ʽ�£���"+rowNum+"���׶εĽ�ֹ�ڴβ���Ϊ��!");
			}
			
			String SEGRPTTERMID = rptObject.getString("SEGRPTTERMID");
			double SEGRPTAMOUNT = rptObject.getDouble("SEGRPTAMOUNT");
			if("5".equals(SEGRPTTERMID)&&SEGRPTAMOUNT<=0d){
				resultInfo.add("����ϻ��ʽ�£���"+rowNum+"���׶λ��ʽΪ�̶�����ʱ����������������!");
			}
			else if(!"5".equals(SEGRPTTERMID)&&SEGRPTAMOUNT>0d){
				resultInfo.add("����ϻ��ʽ�£���"+rowNum+"���׶λ��ʽ��Ϊ�̶�����ʱ����������������!");
			}
			if("5".equals(SEGRPTTERMID)){
				existsFixPrincipal=true;
			}
			
			if(!"5".equals(SEGRPTTERMID) && !"3".equals(SEGRPTTERMID))
			{
				existsOther=true;
			}
			
			if("3".equals(SEGRPTTERMID)){
				businessBalance=businessBalance-SEGRPTAMOUNT;
			}
			else{
				businessBalance=businessBalance-SEGRPTAMOUNT*(segtostage-lastsegtostage);
			}
			
			if(i==rptdata.size()-1){//���һ��
				if("3".equals(SEGRPTTERMID)){
					resultInfo.add("�ִθ�Ϣ������Ϊ���һ�׶λ��ʽ!");
				}
				if(segtostage*paymentFrequencyTerm!=businessTermMonth){
					resultInfo.add("���һ������׶εĽ�ֹ�ڴα�����ڴ�������!");
				}
				if("4".equals(SEGRPTTERMID)&&(segtostage-lastsegtostage)!=1){
					resultInfo.add("��ѡ��һ�λ���ʱ�����������һ�׶ε����һ��!");
				}
			}
			else{
				if("4".equals(SEGRPTTERMID)){
					resultInfo.add("��ѡ��һ�λ���ʱ�����������һ�׶�!");
				}
				if(segtostage*paymentFrequencyTerm > businessTermMonth){
					resultInfo.add("�����һ�λ���׶εĽ�ֹ�ڴα���С�ڴ�������!");
				}
			}
			
			
			
			if(segMap.get(segtostage)==null)
				segMap.put(segtostage,rptObject);
			else{
				resultInfo.add("���������ص���ȱ©!");
			}
			lastsegtostage=segtostage;
		}
		if(existsFixPrincipal&&(Arith.round(businessBalance,2)>1||Arith.round(businessBalance,2)<-1)){
			resultInfo.add("��ѡ�񡰹̶�����+�ִθ�Ϣ��ʱ��¼��ĸ��ڴ����֮���������������С��1Ԫ!");
		}
		
		if(!existsFixPrincipal){//�����ڹ̶���ͨ��
		}
		else if(existsFixPrincipal&&!existsOther){//���ڹ̶������ǲ�����������ʽ����ͨ��
		}
		else{
			resultInfo.add("����ϻ��ʽ�£�������ڹ̶�����ʽ�������н׶εĻ��ʽ�������ǹ̶�������߷ִθ�Ϣ!");
		}
		if(rptdata.size()<2||rptdata.size()>8){
			resultInfo.add("����ϻ��ʽ�£�����Ӧ����2���׶Σ���������8���׶�!");
		}
		
		if(resultInfo.isEmpty())
			return "1";
		else{
			String s="";
			for(String s1:resultInfo){
				s+=s1+"\n";
			}
			return "2@"+s;
		}
	}
	
	
	public String checkRAT(JBOTransaction tx) throws Exception{
		BusinessObject inputObject = this.getInputParameters();
		int businessTermMonth=inputObject.getInt("BusinessTerm");
		List<String> resultInfo=new ArrayList<String>();
		JSONObject ratdata = (JSONObject)this.inputParameter.getValue("ratdata");
		List<BusinessObject> businessObjectArray = new ArrayList<BusinessObject>();
		
		for(int i=0;i<ratdata.size();i++){
			JSONObject data = (JSONObject)ratdata.get(i).getValue();
			int rowNum = (Integer)data.getValue("RowNum")+1;
			BusinessObject rptObject = ObjectWindowHelper.createBusinessObject_JSON(data);
			businessObjectArray.add(rptObject);
			int segtostage = rptObject.getInt("SEGTOSTAGE");
			String rateMode = rptObject.getString("RateMode");
			if(segtostage<=0){
				resultInfo.add("��������ʷ�ʽ�£���"+rowNum+"���׶εĽ�ֹ�ڴβ���Ϊ��!");
			}
			
			if(i==ratdata.size()-1){//���һ��
				if(segtostage!=businessTermMonth){
					resultInfo.add("��������ʷ�ʽ�£����һ���׶εĽ�ֹ���ޱ�����ڴ�������!");
				}
			}
			else{
				if("1".equals(rateMode)){
					resultInfo.add("��������ʷ�ʽ�£���������ֻ�ܳ��������һ�׶�!");
				}
			}
		}
		if(ratdata.size()<2||ratdata.size()>5){
			resultInfo.add("��������ʷ�ʽ�£�����Ӧ����2���׶Σ���������5���׶�!");
		}
		
		if(resultInfo.isEmpty())
			return "1";
		else{
			String s="";
			for(String s1:resultInfo){
				s+=s1+"\n";
			}
			return "2@"+s;
		}
	}
}
