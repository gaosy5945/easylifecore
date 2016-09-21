package com.amarsoft.app.als.ui.treeview;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.json.JSONDecoder;
import com.amarsoft.are.util.json.JSONObject;
import com.amarsoft.awe.RuntimeContext;
import com.amarsoft.awe.control.model.Page;
import com.amarsoft.web.ui.HTMLTreeView;

public abstract class TreeGenerator {
	protected JSONObject inputParameters;
	protected RuntimeContext curARC = null;

	public HTMLTreeView generateTree(Page curPage,HttpServletRequest request) throws Exception{
		curARC=(RuntimeContext)request.getSession().getAttribute("CurARC");
		String inputParameterString=curPage.getAttribute("InputParameters");
		inputParameters=JSONDecoder.decode(inputParameterString);
		HTMLTreeView tviTemp = new HTMLTreeView(null,curPage.getCurComp(),request.getServletPath(),"","right");
		tviTemp.TriggerClickEvent=true; //是否自动触发选中事件
		String multiFlag = (String)getInputParameter("MultiFlag");
		if("true".equalsIgnoreCase(multiFlag))
			tviTemp.MultiSelect = true;//设置树图为多选
		
		List<BusinessObject> treeItemList=getTreeItemList(curPage);
		if(treeItemList!=null&&!treeItemList.isEmpty()){
			for(int i=0;i<treeItemList.size();i++){
				BusinessObject treeItem=treeItemList.get(i);
				String sortNo=treeItem.getString(getSortAttributeID());
				String id = treeItem.getString(getKeyAttributeID());
				String name = treeItem.getString(getNameAttributeID());
				if(StringX.isEmpty(sortNo)) sortNo=id;
				tviTemp.insertPage(sortNo,"root", name , id, "", i);
			}
		}
		tviTemp.packUpItems();
		return tviTemp;
	}
	
	public static TreeGenerator createTreeGenerator(String className) throws ClassNotFoundException, InstantiationException, IllegalAccessException{
		Class<?> c = Class.forName(className);
		TreeGenerator treeSelector = (TreeGenerator)c.newInstance();
		return treeSelector;
	}
	
	public abstract List<BusinessObject> getTreeItemList(Page curPage) throws Exception;
	
	public abstract String getKeyAttributeID() throws Exception;
	
	public abstract String getNameAttributeID() throws Exception;
	
	public abstract String getSortAttributeID() throws Exception;
	
	public Object getInputParameter(String parameterID) throws Exception{
		return inputParameters.getValue(parameterID);
	}
	
}
