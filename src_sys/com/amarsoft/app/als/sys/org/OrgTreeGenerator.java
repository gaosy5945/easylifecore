package com.amarsoft.app.als.sys.org;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.als.ui.treeview.TreeGenerator;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.control.model.Page;


public class OrgTreeGenerator extends TreeGenerator {

	@Override
	public List<BusinessObject> getTreeItemList(Page curPage) throws Exception {
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager();
		String orgFilter = " Status in ('1','0') ";
		String orgFilterParameter = "";
		String orgLevel=(String)getInputParameter("OrgLevel");
		if(!StringX.isEmpty(orgLevel)){
			orgFilter+=" and OrgLevel in (:OrgLevel) ";
			orgFilterParameter+="OrgLevel in "+orgLevel+";";
		}
		
		String orgRangFlag=(String)getInputParameter("OrgRangFlag");
		if("User".equalsIgnoreCase(orgRangFlag)||StringX.isEmpty(orgRangFlag)){
			orgFilter+=" and OrgID in (select OB.BelongOrgID from jbo.sys.ORG_BELONG OB where OB.OrgID in (:OrgID)) ";
			orgFilterParameter+="OrgID in "+this.curARC.getUser().getOrgID()+";";
		}
		
		orgFilter+=" order by SortNo";
		List<BusinessObject> list = bomanager.loadBusinessObjects("jbo.sys.ORG_INFO", orgFilter , orgFilterParameter);
		return list;
	}

	@Override
	public String getKeyAttributeID() throws Exception {
		return "OrgID";
	}

	@Override
	public String getNameAttributeID() throws Exception {
		return "OrgName";
	}

	@Override
	public String getSortAttributeID() throws Exception {
		return "SortNo";
	}

}
