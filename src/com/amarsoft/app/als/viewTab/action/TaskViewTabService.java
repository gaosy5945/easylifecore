package com.amarsoft.app.als.viewTab.action;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.amarsoft.amarscript.Any;
import com.amarsoft.amarscript.Expression;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.ui.widget.Button;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.manage.CodeManager;
import com.amarsoft.dict.als.object.Item;
/**
 * 任务详情服务类
 * @author ghShi
 *
 */
public class TaskViewTabService {
	/**
	 * 根据按钮组及配置的按钮集合，返回按钮属性列表
	 * @param buttonSet
	 * @param buttons
	 * @return
	 * @throws Exception
	 */
	public static List<Button> initButtonItemList(String buttonSet, String buttons) throws Exception{
		List<Button> buttonItemList = new ArrayList<Button>();
		if(!StringX.isEmpty(buttonSet) && !StringX.isEmpty(buttonSet)){
			String[] btArr = buttons.split(",");
			for(String buttonID : btArr){
				if(!StringX.isEmpty(buttonID)){
					Item item = CodeManager.getItem(buttonSet, buttonID);
					buttonItemList.add(new Button(item.getItemName(),item.getItemName(),item.getRelativeCode()));
				}
			}
		}
		
		return buttonItemList;
	}
	
	/**
	 * 根据tab组及配置的tab集合，返回tab属性列表
	 * @param viewTabSet
	 * @param viewTabs
	 * @return
	 * @throws Exception
	 */
	public static List<Item> initViewTabList(String viewTabSet, String viewTabs) throws Exception{
		List<Item> viewTabList = new ArrayList<Item>();
		if(!StringX.isEmpty(viewTabSet) && !StringX.isEmpty(viewTabs)){
			String[] vtArr = viewTabs.split(",");
			for(String vtID : vtArr){
				if(!StringX.isEmpty(vtID))
					viewTabList.add(CodeManager.getItem(viewTabSet, vtID));
			}
		}
		return viewTabList;
	}
	
	/**
	 * 根据tab组及配置的tab集合，形成tab前台展示语句
	 * @param viewTabList
	 * @param argmap
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public static String showViewTabInfo(List<Item> viewTabList, HashMap<String, String> argmap, Transaction Sqlca) throws Exception{
		String viewTabInfo = "";//返回结果
		
		//tab编号，标题和事件
		String tabNo = "Blank";
		String tabTitle = "该流程阶段没有配置功能信息，请确认";
		String tabAction = getOpenComp(tabTitle,tabNo,"/Blank.jsp","");

		//默认打开tab
		String defaultOpenTab = tabNo;
		if(viewTabList.size() == 0){
			viewTabInfo = getTabCompent(tabNo, tabTitle, tabAction);
		} else {
			defaultOpenTab = viewTabList.get(0).getItemNo();
			for(Item tabItem : viewTabList){
				//是否展示tab【true：展示，false：不展示】
				String isShowExp = tabItem.getAttribute3();
				isShowExp = StringFunction.replace(isShowExp, "#ObjectNo", argmap.get("ObjectNo"));
				isShowExp = StringFunction.replace(isShowExp, "#ObjectType", argmap.get("ObjectType"));
			    Any isShow = Expression.getExpressionValue(isShowExp, Sqlca);
			    if ("true".equalsIgnoreCase(isShow.toStringValue())){
			    	//构造tab
			    	tabNo = tabItem.getItemNo();
			    	tabTitle = tabItem.getItemName();
			    	tabAction = getTabAction(tabItem, argmap, Sqlca);
			    	viewTabInfo += getTabCompent(tabNo, tabTitle, tabAction);
				}else{
					continue;
				}
			}
		}
		viewTabInfo += "tabCompent.setSelectedItem(\""+ defaultOpenTab +"\");";			//默认选中项的编号
		
		return viewTabInfo;
	}
	
	/**
	 * 获取Tab的调用对象
	 * @param tabItem
	 * @param argmap
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public static String getTabAction(Item tabItem, HashMap<String, String> argmap, Transaction Sqlca) throws Exception{
		String tabActionExp = tabItem.getItemDescribe();
		String tabActionType = tabItem.getItemAttribute();
		String tabTitle = tabItem.getItemName();
		//调用对象打开方式逻辑,后期整理配置参数方式1，url；2，脚本动态参数；3，脚本既定参数
		if("2".equals(tabActionType)){
			String objectNoExp = tabItem.getAttribute2();
			objectNoExp = StringFunction.replace(objectNoExp, "#ObjectNo", argmap.get("ObjectNo"));
			objectNoExp = StringFunction.replace(objectNoExp, "#ObjectType", argmap.get("ObjectType"));
			Any objectNo = Expression.getExpressionValue(objectNoExp, Sqlca);

			String objectType = tabItem.getAttribute1();
			tabActionExp = StringFunction.replace(tabActionExp, "#ObjectNo", objectNo.toStringValue());
			tabActionExp = StringFunction.replace(tabActionExp, "#ObjectType", objectType);
			tabActionExp = StringFunction.replace(tabActionExp, "#ViewID", argmap.get("ViewID"));
		} else if("3".equals(tabActionType)){

		} else {
			tabActionExp = getOpenComp(tabTitle,tabItem.getItemNo(), tabActionExp, getParamString(argmap));
		}
		return tabActionExp;
	}
	
	/**
	 * 构造URL参数串
	 * @param argmap
	 * @return
	 */
	public static String getParamString(HashMap<String, String> argmap){
		String param = "";
		for(String key : argmap.keySet())
			param += key + "=" + argmap.get(key) + "&";
		return param.substring(0, param.length() - 1);
	}
	
	/**
	 * 构造tabCompent.addDataItem语句
	 * @param tabNo
	 * @param tabTitle
	 * @param tabAction
	 * @return
	 */
	public static String getTabCompent(String tabNo, String tabTitle, String tabAction){
		return "tabCompent.addDataItem(\""+tabNo+"\",\""+tabTitle+"\",\""+tabAction+"\",true,false);\n";
	}
	
	/**
	 * 构造OpenComp语句
	 * @param comp
	 * @param url
	 * @param param
	 * @return
	 */
	public static String getOpenComp(String tabTitle,String comp, String url, String param){
		String frameName = "TabContentFrame";
		return "OpenCompWithTitle('"+tabTitle+"','"+comp+"','"+url+"','"+param+"','"+frameName+"')";
	}
}
