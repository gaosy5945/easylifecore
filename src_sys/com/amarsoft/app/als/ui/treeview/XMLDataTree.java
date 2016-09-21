package com.amarsoft.app.als.ui.treeview;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.XMLHelper;
import com.amarsoft.app.als.ui.treeview.TreeGenerator;
import com.amarsoft.awe.control.model.Page;

public class XMLDataTree extends TreeGenerator{

	private String id;
	private String name;
	private String sortNo;
	
	public List<BusinessObject> getTreeItemList(Page curPage) throws Exception {
		String xmlFile = (String)getInputParameter("XMLFile");
		String xmlTags = (String)getInputParameter("XMLTags");
		String keys = (String)getInputParameter("Keys");
		
		List<BusinessObject> list = XMLHelper.getBusinessObjectList(xmlFile, xmlTags, keys);
		
		id = (String)getInputParameter("ID");
		name = (String)getInputParameter("Name");
		sortNo = (String)getInputParameter("SortNo");
		
		return list;
	}

	public String getKeyAttributeID() {
		return id;
	}

	public String getNameAttributeID() {
		return name;
	}

	public String getSortAttributeID() {
		return sortNo;
	}
	
	

}
