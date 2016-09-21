package com.amarsoft.app.workflow.processdata;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;

public class GetBranchId implements IProcess {

	@Override
	public String process(List<BusinessObject> bos,BusinessObjectManager bomanager,
			String paraName, String dataType, BusinessObject otherPara)
			throws Exception {
		BizObject bo = bos.get(0);
		String operateOrgid = "";	
		String BranchId = "";
		operateOrgid = bo.getAttribute("AccountingOrgID").toString();
		PreparedStatement pstm = bomanager.getConnection().prepareStatement("select orgID from org_info where orgid in (select OrgID from ORG_BELONG where BelongOrgID = ?) and OrgLevel in('2')");
		pstm.setString(1, operateOrgid);
		ResultSet rs = pstm.executeQuery();
		while(rs.next()){
			BranchId = rs.getString("orgID");
			}
		rs.next();
		if(BranchId == null){
			BranchId = "";
		}
		return BranchId;
	}

}
