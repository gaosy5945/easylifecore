package com.amarsoft.app.workflow.processdata;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
/**
 * 获取评分卡评级调用结果
 * @author xjzhao
 */
public class GetImageList implements IProcess {

	public String process(List<BusinessObject> bos, BusinessObjectManager bomanager, String paraName, String dataType,BusinessObject otherPara) throws Exception {
		
		StringBuffer imageList = new StringBuffer();
		
		try
		{
			//imageList.append("<imagelist>");
			for(BusinessObject bo:bos)
			{
				imageList.append("<image>");
				
				//LoanNumber
				imageList.append("<LoanNumber>");
				imageList.append(bo.getString("contractartificialno"));
				imageList.append("</LoanNumber>");
				//InitBranchId
				imageList.append("<InitBranchId>");
				
				String operateOrgid = "";	
				String BranchId = "";
				operateOrgid = bo.getAttribute("AccountingOrgID").toString();
				PreparedStatement pstm = bomanager.getConnection().prepareStatement("select orgID from org_info where orgid in (select OrgID from ORG_BELONG where BelongOrgID = ?) and OrgLevel in('2')");
				pstm.setString(1, operateOrgid);
				ResultSet rs = pstm.executeQuery();
				while(rs.next()){
					BranchId = rs.getString("orgID");
					}
				rs.close();
				if(BranchId == null){
					BranchId = "";
				}
				
				imageList.append(BranchId);
				imageList.append("</InitBranchId>");
				
				//InitOrganizationId
				if(BranchId == null){
					BranchId = operateOrgid;
				}
				imageList.append("<InitOrganizationId>");
				imageList.append(BranchId);
				imageList.append("</InitOrganizationId>");
				
				//BusinessFlag
				imageList.append("<BusinessFlag>");
				imageList.append("0");
				imageList.append("</BusinessFlag>");
				
				//AccountNO
				imageList.append("<AccountNO>");
				imageList.append(bo.getString("contractartificialno"));
				imageList.append("</AccountNO>");
				
				//InitiatorBranchCode
				imageList.append("<InitiatorBranchCode>");
				imageList.append(BranchId.substring(0,2));
				imageList.append("</InitiatorBranchCode>");
				
				//LoanTree
				imageList.append("<LoanTree>");
				if(bo.getString("TreeData") != null && !"".equals(bo.getString("TreeData")))
					imageList.append(bo.getString("TreeData"));
				else if(otherPara != null)
					imageList.append(otherPara.getString("TreeData"));
				imageList.append("</LoanTree>");
				
				//NodeName
				imageList.append("<NodeName>");
				imageList.append("TransformationStatus");
				imageList.append("</NodeName>");
				
				//LoanType
				imageList.append("<LoanType>");
				imageList.append(bo.getString("BusinessType"));
				imageList.append("</LoanType>");
				
				imageList.append("</image>");
			}
			//imageList.append("</imagelist>");
			
		}catch(Exception ex)
		{
			throw ex;
		}
		
		return imageList.toString();//默认
	}

}
