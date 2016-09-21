package com.amarsoft.app.als.ui.function;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.ObjectWindowHelper;
import com.amarsoft.app.base.util.StringHelper;
import com.amarsoft.app.base.util.SystemHelper;
import com.amarsoft.app.als.sys.function.model.FunctionInstance;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.SpecialTools;
import com.amarsoft.awe.control.model.Page;
import com.amarsoft.awe.dw.ASObjectWindow;
import com.amarsoft.dict.als.manage.CodeManager;
import com.amarsoft.web.ui.HTMLTreeView;

/**
 * 功能组件显示
 * @author Administrator
 *
 */
public class FunctionWebTools {
	
	public static String getObjectWindowHTML(FunctionInstance functionInstance,String functionItemID,Page curPage,HttpServletRequest request)
			throws Exception{
		ASObjectWindow dwTemp = FunctionWebTools.getObjectWindow(functionInstance, functionItemID, curPage, request);
		@SuppressWarnings("rawtypes")
		Vector v = dwTemp.genHTMLDataWindow("");
		String html="";
		for(Object s:v){
			html+=(String)s;
		}
		return html;
	}
	
	public static ASObjectWindow getObjectWindow(FunctionInstance functionInstance,String functionItemID,Page curPage,HttpServletRequest request) throws Exception{
		BusinessObject functionItem = functionInstance.getFunctionItem(functionItemID);
		if(functionItem==null) return null;
		
		String templetNo = functionInstance.getFunctionItemParameter(functionItemID, "TempletNo");
		if(templetNo==null) templetNo="";
		String owRightType=functionInstance.getFunctionItemParameter(functionItem, "OWRightType");
		if(owRightType==null) owRightType="0";
		
		String parameterString=functionItem.getString("Parameters");
		BusinessObject inputParameters = StringHelper.stringToBusinessObject(parameterString, "&", "=");
		
		String style = "";
		if(FunctionInstance.FUNCTION_ITEM_TYPE_INFO.equals(functionItem.getString("FunctionType"))){
			style="2";
		}
		else if(FunctionInstance.FUNCTION_ITEM_TYPE_LIST.equals(functionItem.getString("FunctionType"))){
			style="1";
		}
		String dwcount = curPage.getAttribute("SYS_DWCOUNT");
		if(StringX.isEmpty(dwcount))dwcount="0";
		else dwcount=String.valueOf(Integer.valueOf(dwcount)+1);
		ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow(templetNo,dwcount,style,owRightType,inputParameters,curPage,request);
		return dwTemp;
	}
	
	
	/**
	 * {"true","","Button","保存","保存修改","saveRecord()","","","",""},//btn_icon_save 
	 * @param codeNo
	 * @param sortNo
	 * @return
	 * @throws Exception
	 */
	public static String[][] genButtons(FunctionInstance functionInstance,String functionItemID) throws Exception{
		List<BusinessObject> list = functionInstance.getFunctionItemList(functionItemID, FunctionInstance.FUNCTION_ITEM_TYPE_BUTTON);
		if(list==null||list.isEmpty()) return null;
		String[][] buttons=new String[list.size()][10];
		for(int i=0;i<list.size();i++){
			BusinessObject functionItem=list.get(i);
			buttons[i][0]="true";
			String rightType=functionItem.getString("RightType");
			if(rightType.equalsIgnoreCase("hide") || rightType.equalsIgnoreCase("ReadOnly")) {
				buttons[i][0]="false";
			}
		
			buttons[i][1]="All";
			buttons[i][2]="Button";
			buttons[i][3]=functionItem.getString("FunctionItemName");
			buttons[i][4]=functionItem.getString("FunctionItemName");
			buttons[i][5]=functionItem.getString("URL");
			buttons[i][6]=functionItem.getString("FUNCTIONSUBTYPE");
			buttons[i][7]="";
			buttons[i][8]="";
			buttons[i][9]="";
		}
		return buttons;
	}
	
	/**
	 * 产生树图
	 * @param tviTemp
	 * @throws Exception
	 */
	public static void genHTMLTreeView(HTMLTreeView tviTemp,FunctionInstance functionInstance,String parentFunctionItemID) throws Exception{
		List<BusinessObject> functionItemList = functionInstance.getFunctionItemList(parentFunctionItemID
				,FunctionInstance.FUNCTION_ITEM_TYPE_TREE+","+FunctionInstance.FUNCTION_ITEM_TYPE_FTREE);
		if(functionItemList==null||functionItemList.isEmpty()) return;
		if(StringX.isEmpty(parentFunctionItemID))parentFunctionItemID="root";
		else{
			BusinessObject functionItem = functionInstance.getFunctionItem(parentFunctionItemID);
			if(functionItem==null) parentFunctionItemID="root";
			else {
				String functionItemType = functionItem.getString("FunctionType");
				if(!FunctionInstance.FUNCTION_ITEM_TYPE_TREE.equals(functionItemType)
						&&!FunctionInstance.FUNCTION_ITEM_TYPE_FTREE.equals(functionItemType)){
					parentFunctionItemID="root";
				}
			}
		}

		int i=tviTemp.getItemCount()+1;
		for(BusinessObject functionItem:functionItemList){
			String functionItemID = functionItem.getString("FunctionItemID");
			if(functionItemID==null||functionItemID.length()==0) 
				throw new Exception("功能点编号FunctionItemID为空！");
			
			if(functionItemID.equals(parentFunctionItemID)) 
				throw new Exception("功能点编号FunctionItemID重复！");
			
			String functionItemName=functionItem.getString("FunctionItemName");

			List<BusinessObject> childernList = functionInstance.getFunctionItemList(functionItemID
					,FunctionInstance.FUNCTION_ITEM_TYPE_TREE+","+FunctionInstance.FUNCTION_ITEM_TYPE_FTREE);
			boolean folderFlag = false;
			if(functionItem.getString("FunctionType").equals(FunctionInstance.FUNCTION_ITEM_TYPE_FTREE)){
				folderFlag=true;
			}
			else{
				if(childernList!=null&&!childernList.isEmpty()) folderFlag=true;
			}
			
			String url = functionItem.getString("URL");
			if(StringX.isEmpty(url)){
				if(childernList==null||childernList.isEmpty())
					url =FunctionWebTools.getFunctionURL(functionInstance, functionItem);
			}

			String script = "";
			String parameters = getFunctionWebParameters(functionInstance,functionItem);
			if(!StringX.isEmpty(url)){
				script=url+"@"+parameters;
			}
				
			if(folderFlag)
				tviTemp.insertFolder(functionItemID,parentFunctionItemID, functionItemName ,script , "", i++);
			else
				tviTemp.insertPage(functionItemID,parentFunctionItemID, functionItemName , script, "", i++);

			genHTMLTreeView(tviTemp,functionInstance,functionItemID);
		}
		tviTemp.packUpItems();
	}

	
	/**
	 * 获得转化后的Parameter
	 * @param bo
	 * @return
	 * @throws Exception
	 */
	public static String getFunctionWebParameters(FunctionInstance functionInstance,BusinessObject functionItem) throws Exception{
		String functionID = functionInstance.getFunction().getString("FunctionID");
		String parameters=getFunctionParameters(functionInstance);
		parameters +="&SYS_FUNCTIONITEMID_"+functionID+"="+functionItem.getString("FunctionItemID");
		if(!StringX.isEmpty(functionItem.getString("RightType"))){
			parameters +="&RightType="+functionItem.getString("RightType");
		}
		parameters +="&"+functionItem.getString("Parameters");
		return parameters;
	}
	
	private static String getFunctionParameters(FunctionInstance functionInstance) throws Exception{
		String parameters="";
		String[] keys = functionInstance.getAllFunctionParameter().getAttributeIDArray();
		for(String key:keys){
			if(key.startsWith("SYS_FUNCTION")) continue;
			Object obj=functionInstance.getAllFunctionParameter().getObject(key);
			if(obj==null) continue;
			String value=String.valueOf(obj);
			value=SpecialTools.real2Amarsoft(value);
			if(parameters.length()==0)
				parameters=key+"="+value;
			else
				parameters+="&"+key+"="+value;
		}
		return "";
	}
	
	public static String getFunctionWebParameters(FunctionInstance functionInstance,String functionItemID) throws Exception{
		if(StringX.isEmpty(functionItemID)) return getFunctionParameters(functionInstance);
		BusinessObject functionItem = functionInstance.getFunctionItem(functionItemID);
		return FunctionWebTools.getFunctionWebParameters(functionInstance, functionItem);
	}
	
	/**
	 * 获得页面中所有参数，排除系统参数
	 * @param CurPage
	 * @return
	 * @throws Exception 
	 */
	public static String getPageStringParmeters(Page curPage) throws Exception{
		BusinessObject parameters = SystemHelper.getPageComponentParameters(curPage);
		String[] a= parameters.getAttributeIDArray();
		String s="";
		for(String parameterID:a){
			if(s.length()==0) s=parameterID+"="+parameters.getString(parameterID);
			else s+="&"+parameterID+"="+parameters.getString(parameterID);
		}
		return s;
	}
	
	/**
	 * 获得转化后的URL
	 * @param bo
	 * @return
	 * @throws Exception
	 */
	public static String getFunctionURL(FunctionInstance functionInstance,BusinessObject functionItem) throws Exception{
		String url="";
		String functionItemID = "";
		if(functionItem!=null){
			url = functionItem.getString("URL");
			
			functionItemID= functionItem.getString("FunctionItemID");
		}
		else{
			url=functionInstance.getFunction().getString("URL");
		}
		if(!StringX.isEmpty(url)) return url;
		
		List<BusinessObject> itemList = functionInstance.getFunctionItemList(functionItemID);
		if(itemList==null||itemList.isEmpty()) return "";
		for(BusinessObject item:itemList){
			String functionType=item.getString("FunctionType");
			url=CodeManager.getItem("FunctionType", functionType).getItemDescribe();
			if(!StringX.isEmpty(url)) return url;
		}
		if(StringX.isEmpty(url)) return "";
		return url;
	}
	
	/**
	 * 获得转化后的URL
	 * @param bo
	 * @return
	 * @throws Exception
	 */
	public static String getFunctionURL(FunctionInstance functionInstance,String functionItemID) throws Exception{
		BusinessObject functionItem = functionInstance.getFunctionItem(functionItemID);
		return FunctionWebTools.getFunctionURL(functionInstance, functionItem);
	}

	/**
	 * 获得左右区域
	 * @return
	 * @throws Exception
	 */
	public static String[][] getLeftRightPages(FunctionInstance functionInstance,String parentFunctionItemID) throws Exception{
		String[][] pages = new String[2][3];

		List<BusinessObject> functionItemList = functionInstance.getFunctionItemList(parentFunctionItemID,FunctionInstance.FUNCTION_ITEM_TYPE_LEFT);
		if(functionItemList==null||functionItemList.isEmpty())  throw new Exception("无效的定义，没有定义左侧页面！");
		else if(functionItemList.size()>1) throw new Exception("无效的定义，存在多个左侧页面！");
		else{
			BusinessObject functionItem = functionItemList.get(0);
			String functionItemID=functionItem.getString("FunctionItemID");
			pages[0][0] = functionItemID;
			pages[0][1] = getFunctionURL(functionInstance,functionItem);
			pages[0][2] = getFunctionWebParameters(functionInstance,functionItem);
		}
		
		functionItemList = functionInstance.getFunctionItemList(parentFunctionItemID,FunctionInstance.FUNCTION_ITEM_TYPE_RIGHT);
		if(functionItemList==null||functionItemList.isEmpty())  throw new Exception("无效的定义，没有定义右侧页面！");
		else if(functionItemList.size()>1) throw new Exception("无效的定义，存在多个右侧页面！");
		else{
			BusinessObject functionItem = functionItemList.get(0);
			String functionItemID=functionItem.getString("FunctionItemID");
			pages[1][0] = functionItemID;
			pages[1][1] = getFunctionURL(functionInstance,functionItem);
			pages[1][2] = getFunctionWebParameters(functionInstance,functionItem);
		}
		return pages;
	}
	
	/**
	 * 获得上下区域
	 * @return
	 * @throws Exception
	 */
	public static String[][] getUpDownPages(FunctionInstance functionInstance,String parentFunctionItemID) throws Exception{
		String[][] pages = new String[2][3];

		List<BusinessObject> functionItemList = functionInstance.getFunctionItemList(parentFunctionItemID,FunctionInstance.FUNCTION_ITEM_TYPE_TOP);
		if(functionItemList==null||functionItemList.isEmpty())  throw new Exception("无效的定义，没有定义上方页面！");
		else if(functionItemList.size()>1) throw new Exception("无效的定义，存在多个上方页面！");
		else{
			BusinessObject functionItem = functionItemList.get(0);
			String functionItemID=functionItem.getString("FunctionItemID");
			
			pages[0][0] = functionItemID;
			pages[0][1] = getFunctionURL(functionInstance,functionItem);
			pages[0][2] = getFunctionWebParameters(functionInstance,functionItem);
		}
		
		functionItemList = functionInstance.getFunctionItemList(parentFunctionItemID,FunctionInstance.FUNCTION_ITEM_TYPE_BOTTOM);
		if(functionItemList==null||functionItemList.isEmpty())  throw new Exception("无效的定义，没有定义底部页面！");
		else if(functionItemList.size()>1) throw new Exception("无效的定义，存在多个底部页面！");
		else{
			BusinessObject functionItem = functionItemList.get(0);
			String functionItemID=functionItem.getString("FunctionItemID");
			
			pages[1][0] = functionItemID;
			pages[1][1] = getFunctionURL(functionInstance,functionItem);
			pages[1][2] = getFunctionWebParameters(functionInstance,functionItem);
		}
		return pages;
	}
	
	/**
	 * 将字符串转化为参数
	 * @param parameters
	 * @return
	 */
	public static Map<String,Object> getParameter(String parameters){
		Map<String,Object> map=new HashMap<String,Object>();
		String[] par=parameters.split("&");
		for(String sp:par){
			String[] p1=sp.split("=");
			if(p1.length==2){
				map.put(p1[0], p1[1]);
			}else{
				map.put(p1[0],"");
			}
		}
		return map;
	}
}
