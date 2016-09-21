package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
/**
 * 
 * @author 梁建强
 *功能：检查是否与经营类贷款相关（贷后检查）
 */
public class CheckOperateLoanRelative extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{	
		String sObjectNo=(String)this.getAttribute("ObjectNo");//对象编号
		String sCreditInspectType = (String)this.getAttribute("CreditInspectType");//贷后检查类型 02:资金用途检查 ， 05：合作项目检查 ，06 合作方检查
		String sInspectAction =(String) this.getAttribute("inspectAction");
		if(sObjectNo==null) sObjectNo="";
		if(sCreditInspectType==null) sCreditInspectType="";
		if(sInspectAction==null) sInspectAction="";
        String sSql = "";
        ASResultSet rs = null;
        String sContractNo = "";
        String sCustomerID ="";
        String sProductType3 = "";//消费/经营(CodeNo:ProductType3) 02:经营类贷款
        String sReturn = "";
        String sRiskLevel ="";	
        String sOverFlag = "";
        String sProductType = "";
        
		try{
			if("02".equals(sCreditInspectType)){//此时sObjectNo为借据编号
				sSql = "select ContractSerialNo,CustomerID from Business_Duebill where SerialNo='"+sObjectNo+"'";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next()){
					sContractNo = rs.getString("ContractSerialNo");
					sCustomerID = rs.getString("CustomerID");
				}
				rs.getStatement().close();
				
				sSql = "select ProductType3 from PRD_PRODUCT_LIBRARY ppl "+
				 " where exists(select 'x' from Business_Duebill where SerialNo='"+sObjectNo+"' and ((ProductID=ppl.ProductID and ProductID is not null) or (BusinessType=ppl.ProductID and ProductID is null)) )";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next()){
					sProductType3 = rs.getString(1);
				}
				rs.getStatement().close();
				if(sProductType3==null) sProductType3="";
				//取得客户预警信息
				sSql = "select CSTRISKLEVEL from CUSTOMER_INFO where CustomerID='"+sCustomerID+"'";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next()){
					sRiskLevel = rs.getString("CSTRISKLEVEL");
				}
				rs.getStatement().close();
				if(sRiskLevel==null) sRiskLevel="";
				if("02".endsWith(sProductType3)&&((!"".equals(sRiskLevel)||"02".equals(sInspectAction)))){
					sReturn="true";
				}
			}else if("03".equals(sCreditInspectType)){
				sSql = "select ContractSerialNo,CustomerID,case when overduebalance>0 then 'yes' else 'no' end as overFlag from Business_Duebill where SerialNo='"+sObjectNo+"'";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next()){
					sContractNo = rs.getString("ContractSerialNo");
					sCustomerID = rs.getString("CustomerID");
					sOverFlag = rs.getString("overFlag");
				}
				rs.getStatement().close();
				if(sContractNo==null) sContractNo="";
				if(sCustomerID==null) sCustomerID="";
				if(sOverFlag==null) sOverFlag="";
				
				sSql = "select ProductType3 from PRD_PRODUCT_LIBRARY ppl "+
				 " where exists(select 'x' from Business_Duebill where SerialNo='"+sObjectNo+"' and ((ProductID=ppl.ProductID and ProductID is not null) or (BusinessType=ppl.ProductID and ProductID is null)) )";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next()){
					sProductType3 = rs.getString(1);
				}
				rs.getStatement().close();
				if(sProductType3==null) sProductType3="";
				//取得客户预警信息
				sSql = "select CSTRISKLEVEL from CUSTOMER_INFO where CustomerID='"+sCustomerID+"'";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next()){
					sRiskLevel = rs.getString("CSTRISKLEVEL");
				}
				rs.getStatement().close();
				if(sRiskLevel==null) sRiskLevel="";
				
				if("02".endsWith(sProductType3)&&((!"".equals(sRiskLevel)||"yes".equals(sOverFlag)))){
					sReturn="true";
				}
			}else if("05".equals(sCreditInspectType)){//此时sObjectNo为项目编号 ,PRJ_BASIC_INFO.SerialNo=PRJ_RELATIVE.ProjectSerialNo
				sSql = "select PROJECTTYPE from PRJ_BASIC_INFO where SerialNo='"+sObjectNo+"' ";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next()){
					sProductType = rs.getString(1);
				}
				rs.getStatement().close();
				if(sProductType==null) sProductType="";
				if("0103".equals(sProductType)||"0107".equals(sProductType)){
					sReturn = "true";
				}	
			}else if("06".equals(sCreditInspectType)){//此时sObjectNo为合作项目方编号：CUSTOMER_LIST.SerialNo
				sSql = "select PR.ObjectNo from PRJ_RELATIVE PR,PRJ_BASIC_INFO PBI,CUSTOMER_LIST CL "+
			           " where PR.ProjectSerialNo=PBI.SerialNo and CL.CustomerID=PBI.CustomerID and CL.SerialNo='"+sObjectNo+"'"+
					   " and PR.ObjectType='jbo.app.BUSINESS_CONTRACT'";
				rs = Sqlca.getASResultSet(sSql);
				while(rs.next()){
					sContractNo = rs.getString(1);
					sSql = "select ProductType3 from PRD_PRODUCT_LIBRARY ppl "+
							 " where exists(select 'x' from Business_Duebill where ContractSerialno='"+sContractNo+"' "
							 		+ "and ((ProductID=ppl.ProductID and ProductID is not null) or"
							 		+ " (BusinessType=ppl.ProductID and ProductID is null)) "
							 		+ " AND finishdate is null) ";
					sProductType3 = Sqlca.getString(sSql);
					if("02".equals(sProductType3)){
						sReturn = "true";
						break;
					}
				}
				rs.getStatement().close();
			}
			
			return sReturn;
		}catch(Exception ex){
			throw ex;
		}
	}
	
}
