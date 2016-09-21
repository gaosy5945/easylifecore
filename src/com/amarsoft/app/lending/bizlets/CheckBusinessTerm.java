package com.amarsoft.app.lending.bizlets;

import org.mozilla.javascript.ast.ContinueStatement;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.als.prd.analysis.ProductAnalysisFunctions;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * ��������ס������״�����ת�����޺ͻ��ʽ�Ƿ����Ҫ��
 * @author ������
 */
public class CheckBusinessTerm extends Bizlet {
	public Object  run(Transaction Sqlca) throws Exception {
		//���̱�š��û����
		String serialNo = (String)this.getAttribute("SerialNo");
		String businessTerm = (String)this.getAttribute("BusinessTerm");
		if("".equals(businessTerm) || businessTerm == null) businessTerm = "0";
		String RPTTermID = (String)this.getAttribute("RPTTermID");
		String message = "";
		
		SqlObject bc = new SqlObject("select BusinessType,CustomerID,MaturityDate from BUSINESS_CONTRACT where SerialNo=:SerialNo");
		bc.setParameter("SerialNo", serialNo);
		ASResultSet rs = Sqlca.getASResultSet(bc);
		if(rs.next())
		{
			String customerID = rs.getString("CustomerID");
			String birthDay = Sqlca.getString(new SqlObject("select BirthDay from IND_INFO where CustomerID = :CustomerID").setParameter("CustomerID",customerID));
			String maturityDate = rs.getString("MaturityDate");
			int birthYear = Integer.parseInt(birthDay.substring(0, 4));
			
			int upMonths = (int) Math.floor(DateHelper.getMonths(birthDay, maturityDate));
			int BusinessTrem = Integer.parseInt(businessTerm);
			int sumMonths = upMonths+BusinessTrem;
			
			BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
			BusinessObject bcObject = bom.keyLoadBusinessObject("jbo.app.BUSINESS_CONTRACT", serialNo);
			double indTermAge = ProductAnalysisFunctions.getComponentMaxValue(bcObject, "PRD01-01", "IndTermAge", "", "02");
			double maxBusinesTerm = ProductAnalysisFunctions.getComponentMaxValue(bcObject, "PRD02-01", "BusinessTerm", "", "02");
			//double minBusinesTerm = ProductAnalysisFunctions.getComponentMinValue(bcObject, "PRD02-01", "BusinessTerm", "", "02");
			int MaxYear = birthYear+Integer.valueOf((int)indTermAge);
			String MaxDate = MaxYear+birthDay.substring(4, 10);
			
			if("666".equals(rs.getString("BusinessType"))){
				if((double)sumMonths > indTermAge*12){
					message = "false@BusinessTerm@������ת�����޲�����Ҫ�󣬸������˵ĳ�������Ϊ��"+birthDay+"������ȵ�����+ת�����޲��ó�����"+MaxDate+"�������޸�ת������ ���� ��ע����ȵ�����Ϊ��"+maturityDate+"����";
				}else if((double)BusinessTrem > maxBusinesTerm){
					message = "false@BusinessTerm@������ת�����޲��ܳ���"+maxBusinesTerm/12+"��!";
				}else if(BusinessTrem <= 12){
					if(!"RPT-01".equals(RPTTermID) && !"RPT-02".equals(RPTTermID) && !"RPT-03".equals(RPTTermID) && !"RPT-04".equals(RPTTermID)){
						message = "false@RPTTermID@���ʽ����ת������һ�꣨�������ڣ���ѡ�ȶϢ���ȶ��һ�λ�����Ϣ�Ͱ��ڸ�Ϣһ�λ���!";
					}
				}else if(BusinessTrem > 12 &&  BusinessTrem<= 120){
					if(!"RPT-01".equals(RPTTermID) && !"RPT-02".equals(RPTTermID)){
						message = "false@RPTTermID@���ʽ����ת��������һ�����ϣ���ѡ�ȶϢ�͵ȶ��!";
					}
				}
			}
			if("500".equals(rs.getString("BusinessType")) || "502".equals(rs.getString("BusinessType"))){
				if((double)sumMonths > indTermAge*12){
					message = "false@BusinessTerm@������ת�����޲�����Ҫ�󣬸������˵ĳ�������Ϊ��"+birthDay+"������ȵ�����+ת�����޲��ó�����"+MaxDate+"�������޸�ת�����ޣ��� ��ע����ȵ�����Ϊ��"+maturityDate+"����";
				}else if((double)BusinessTrem > maxBusinesTerm){
					message = "false@BusinessTerm@������ת�����޲��ܳ���"+maxBusinesTerm/12+"��";
				}else if(BusinessTrem <= 12){
					if(!"RPT-01".equals(RPTTermID) && !"RPT-02".equals(RPTTermID) && !"RPT-03".equals(RPTTermID) && !"RPT-04".equals(RPTTermID)){
						message = "false@RPTTermID@���ʽ����ת������һ�꣨�������ڣ���ѡ�ȶϢ���ȶ��һ�λ�����Ϣ�Ͱ��ڸ�Ϣһ�λ���!";
					}
				}
			}
		}
		rs.close();
		if("".equals(message)){
			return "true@";
		}else{
			return message;
		}
	}
	
}
