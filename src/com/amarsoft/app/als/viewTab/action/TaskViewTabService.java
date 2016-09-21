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
 * �������������
 * @author ghShi
 *
 */
public class TaskViewTabService {
	/**
	 * ���ݰ�ť�鼰���õİ�ť���ϣ����ذ�ť�����б�
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
	 * ����tab�鼰���õ�tab���ϣ�����tab�����б�
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
	 * ����tab�鼰���õ�tab���ϣ��γ�tabǰ̨չʾ���
	 * @param viewTabList
	 * @param argmap
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public static String showViewTabInfo(List<Item> viewTabList, HashMap<String, String> argmap, Transaction Sqlca) throws Exception{
		String viewTabInfo = "";//���ؽ��
		
		//tab��ţ�������¼�
		String tabNo = "Blank";
		String tabTitle = "�����̽׶�û�����ù�����Ϣ����ȷ��";
		String tabAction = getOpenComp(tabTitle,tabNo,"/Blank.jsp","");

		//Ĭ�ϴ�tab
		String defaultOpenTab = tabNo;
		if(viewTabList.size() == 0){
			viewTabInfo = getTabCompent(tabNo, tabTitle, tabAction);
		} else {
			defaultOpenTab = viewTabList.get(0).getItemNo();
			for(Item tabItem : viewTabList){
				//�Ƿ�չʾtab��true��չʾ��false����չʾ��
				String isShowExp = tabItem.getAttribute3();
				isShowExp = StringFunction.replace(isShowExp, "#ObjectNo", argmap.get("ObjectNo"));
				isShowExp = StringFunction.replace(isShowExp, "#ObjectType", argmap.get("ObjectType"));
			    Any isShow = Expression.getExpressionValue(isShowExp, Sqlca);
			    if ("true".equalsIgnoreCase(isShow.toStringValue())){
			    	//����tab
			    	tabNo = tabItem.getItemNo();
			    	tabTitle = tabItem.getItemName();
			    	tabAction = getTabAction(tabItem, argmap, Sqlca);
			    	viewTabInfo += getTabCompent(tabNo, tabTitle, tabAction);
				}else{
					continue;
				}
			}
		}
		viewTabInfo += "tabCompent.setSelectedItem(\""+ defaultOpenTab +"\");";			//Ĭ��ѡ����ı��
		
		return viewTabInfo;
	}
	
	/**
	 * ��ȡTab�ĵ��ö���
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
		//���ö���򿪷�ʽ�߼�,�����������ò�����ʽ1��url��2���ű���̬������3���ű��ȶ�����
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
	 * ����URL������
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
	 * ����tabCompent.addDataItem���
	 * @param tabNo
	 * @param tabTitle
	 * @param tabAction
	 * @return
	 */
	public static String getTabCompent(String tabNo, String tabTitle, String tabAction){
		return "tabCompent.addDataItem(\""+tabNo+"\",\""+tabTitle+"\",\""+tabAction+"\",true,false);\n";
	}
	
	/**
	 * ����OpenComp���
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
