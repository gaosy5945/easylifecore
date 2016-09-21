package com.amarsoft.app.als.viewTab.model;

import java.util.List;

import com.amarsoft.app.als.viewTab.action.TaskViewTabService;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.ui.widget.Button;
import com.amarsoft.dict.als.manage.CodeManager;
import com.amarsoft.dict.als.object.Item;

/**
 * ��������Tab�����������
 * @author ghShi
 * @since  2014/04/09
 */
public class TaskViewTab {
	private String taskID;					//���
	private String taskName;				//����
	private String buttonSet;				//��ť��
	private String buttons;					//��Ҫչʾ�İ�ť���
	private String viewTabSet;				//tab��
	private String viewTabs;				//��Ҫչʾ��tab���
	private String requiredViewTabs;		//��Ҫ���������tab
	
	private List<Button> buttonItemList;	//��ť�������
	private List<Item> viewTabItemList;		//tab�������

	/**
	 * ���������ţ���ʼ����������tab
	 * @param taskID
	 */
	public TaskViewTab(String taskID){
		this.taskID = taskID;
		try {
			initTaskViewTab();
			initButtonItemList();
			initViewTabItemList();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * ��ʼ��������Ϣ
	 * @throws Exception
	 */
	private void initTaskViewTab() throws Exception{
		Item item = CodeManager.getItem(ViewTabConst.TASK_VIEW_TAB, taskID);
		if(item == null) throw new Exception("���������Ŵ�����ο�����code:TaskViewTab��");
		this.setTaskName(item.getItemName());
		this.setButtonSet(item.getAttribute1());
		this.setButtons(item.getAttribute2());
		this.setViewTabSet(item.getAttribute3());
		this.setViewTabs(item.getAttribute4());
		this.setRequiredViewTabs(item.getAttribute5());
	}
	
	/**
	 * ��ʼ����Ҫչʾ�İ�ť���������
	 * @throws Exception
	 */
	private void initButtonItemList() throws Exception{
		this.buttonItemList = TaskViewTabService.initButtonItemList(this.buttonSet, this.buttons);
	}
	
	/**
	 * ��ʼ����Ҫչʾ��tab���������
	 * @throws Exception
	 */
	private void initViewTabItemList() throws Exception{
		this.viewTabItemList = TaskViewTabService.initViewTabList(viewTabSet, viewTabs);
		//���tabΪ�ص��ʾ�չʾʱ����ǰ���Ϻ�ɫ'*'
/*		if("ALL".equalsIgnoreCase(this.requiredViewTabs)){
			for(Item item : viewTabItemList)
				item.setAttribute8(ViewTabConst.REQUIRED_FLAG);
			return;
		}
		
		if(!StringX.isEmpty(this.requiredViewTabs)){
			for(Item item : viewTabItemList)
				if(this.requiredViewTabs.contains(item.getItemNo()))
					item.setAttribute8(ViewTabConst.REQUIRED_FLAG);
		}*/
	}
	
	/**
	 * ������Ҫչʾ�İ�ť
	 * @param buttonItem
	 */
	public void addButtonItem(Button buttonItem) {
		this.buttonItemList.add(buttonItem);
	}
	
	/**
	 * ������Ҫչʾ��tab
	 * @param ViewTabItem
	 */
	public void addViewTabItem(Item ViewTabItem) {
		this.viewTabItemList.add(ViewTabItem);
	}
	
	
	
	public String getTaskID() {
		return taskID;
	}

	public void setTaskID(String taskID) {
		this.taskID = taskID;
	}

	public String getTaskName() {
		return taskName;
	}

	public void setTaskName(String taskName) {
		this.taskName = taskName;
	}
	
	public String getButtonSet() {
		return buttonSet;
	}
	
	public void setButtonSet(String buttonSet) {
		this.buttonSet = buttonSet;
	}
	
	public String getViewTabSet() {
		return viewTabSet;
	}
	
	public void setViewTabSet(String viewTabSet) {
		this.viewTabSet = viewTabSet;
	}
	
	public String getRequiredViewTabs() {
		return requiredViewTabs;
	}
	
	public void setRequiredViewTabs(String requiredViewTabs) {
		this.requiredViewTabs = requiredViewTabs;
	}
	
	public String getButtons() {
		return buttons;
	}

	public void setButtons(String buttons) {
		this.buttons = buttons;
	}

	public String getViewTabs() {
		return viewTabs;
	}

	public void setViewTabs(String viewTabs) {
		this.viewTabs = viewTabs;
	}

	public List<Button> getButtonItemList() {
		return buttonItemList;
	}

	public void setButtonItemList(List<Button> buttonItemList) {
		this.buttonItemList = buttonItemList;
	}

	public List<Item> getViewTabItemList() {
		return viewTabItemList;
	}

	public void setViewTabItemList(List<Item> viewTabItemList) {
		this.viewTabItemList = viewTabItemList;
	}
}
