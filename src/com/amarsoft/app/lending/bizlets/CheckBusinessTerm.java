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
 * 检查消贷易、融资易贷后变更转贷期限和还款方式是否符合要求
 * @author 张万亮
 */
public class CheckBusinessTerm extends Bizlet {
	public Object  run(Transaction Sqlca) throws Exception {
		//流程编号、用户编号
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
					message = "false@BusinessTerm@消贷易转贷期限不符合要求，该申请人的出生日期为【"+birthDay+"】，额度到期日+转贷期限不得超过【"+MaxDate+"】，请修改转贷期限 ！！ （注：额度到期日为【"+maturityDate+"】）";
				}else if((double)BusinessTrem > maxBusinesTerm){
					message = "false@BusinessTerm@消贷易转贷期限不能超过"+maxBusinesTerm/12+"年!";
				}else if(BusinessTrem <= 12){
					if(!"RPT-01".equals(RPTTermID) && !"RPT-02".equals(RPTTermID) && !"RPT-03".equals(RPTTermID) && !"RPT-04".equals(RPTTermID)){
						message = "false@RPTTermID@还款方式有误，转贷期限一年（含）以内，可选等额本息、等额本金、一次还本付息和按期付息一次还本!";
					}
				}else if(BusinessTrem > 12 &&  BusinessTrem<= 120){
					if(!"RPT-01".equals(RPTTermID) && !"RPT-02".equals(RPTTermID)){
						message = "false@RPTTermID@还款方式有误，转贷期限在一年以上，可选等额本息和等额本金!";
					}
				}
			}
			if("500".equals(rs.getString("BusinessType")) || "502".equals(rs.getString("BusinessType"))){
				if((double)sumMonths > indTermAge*12){
					message = "false@BusinessTerm@融资易转贷期限不符合要求，该申请人的出生日期为【"+birthDay+"】，额度到期日+转贷期限不得超过【"+MaxDate+"】，请修改转贷期限！！ （注：额度到期日为【"+maturityDate+"】）";
				}else if((double)BusinessTrem > maxBusinesTerm){
					message = "false@BusinessTerm@融资易转贷期限不能超过"+maxBusinesTerm/12+"年";
				}else if(BusinessTrem <= 12){
					if(!"RPT-01".equals(RPTTermID) && !"RPT-02".equals(RPTTermID) && !"RPT-03".equals(RPTTermID) && !"RPT-04".equals(RPTTermID)){
						message = "false@RPTTermID@还款方式有误，转贷期限一年（含）以内，可选等额本息、等额本金、一次还本付息和按期付息一次还本!";
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
