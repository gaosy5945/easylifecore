package com.amarsoft.app.als.credit.guaranty.guarantycontract;

import java.util.Date;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.awe.util.DBKeyHelp;

public class GetGCContractNo {

	//生成最高额担保的ContractNo 机构+年份+10位
	public static String getCeilingGCContractNo(BusinessObject gc) throws Exception{
		//BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
		
		String orgID = gc.getString("InputOrgID");
		/*String year = gc.getString("InputDate").substring(0, 4);
		List<BusinessObject> gcList = bom.loadBusinessObjects("jbo.guaranty.GUARANTY_CONTRACT", "ContractType='020' and "
				+ "InputOrgID=:OrgID and InputDate like :Date", "OrgID",orgID,"Date",year+"%");
		
		String sno = "";
		sno += orgID;
		sno += year;
		
		String index = String.valueOf(gcList.size()+1);
		int k = 0;
		while(10-index.length()-k>0){
			sno += "0";
			k++;
		}
		sno += index;*/
		
		String sno = DBKeyHelp.getSerialNo("GUARANTY_CONTRACT", "ContractNo", orgID+"yyyy9", "000000000", new Date());
		
		return sno;
	}
	
	public static String getCeilingGCContractNo(String orgID) throws Exception{
		String sno = DBKeyHelp.getSerialNo("GUARANTY_CONTRACT", "ContractNo", orgID+"yyyy9", "000000000", new Date());
		return sno;
	}
	
	//一般担保
	public static String getGCContractNo(String artificialNo) throws Exception{
		if(artificialNo != null && artificialNo.length() >= 14) artificialNo = artificialNo.substring(0, 14);
		String sno = DBKeyHelp.getSerialNo("GUARANTY_CONTRACT", "ContractNo", artificialNo, "0000", new Date());
		return sno;
	}
}
