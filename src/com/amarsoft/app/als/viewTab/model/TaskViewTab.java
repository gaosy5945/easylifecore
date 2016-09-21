package com.amarsoft.app.als.viewTab.model;

import java.util.List;

import com.amarsoft.app.als.viewTab.action.TaskViewTabService;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.ui.widget.Button;
import com.amarsoft.dict.als.manage.CodeManager;
import com.amarsoft.dict.als.object.Item;

/**
 * 任务详情Tab界面相关属性
 * @author ghShi
 * @since  2014/04/09
 */
public class TaskViewTab {
	private String taskID;					//编号
	private String taskName;				//名称
	private String buttonSet;				//按钮组
	private String buttons;					//需要展示的按钮编号
	private String viewTabSet;				//tab组
	private String viewTabs;				//需要展示的tab编号
	private String requiredViewTabs;		//需要处理任务的tab
	
	private List<Button> buttonItemList;	//按钮相关属性
	private List<Item> viewTabItemList;		//tab相关属性

	/**
	 * 根据任务编号，初始化任务详情tab
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
	 * 初始化基本信息
	 * @throws Exception
	 */
	private void initTaskViewTab() throws Exception{
		Item item = CodeManager.getItem(ViewTabConst.TASK_VIEW_TAB, taskID);
		if(item == null) throw new Exception("传入的任务号错误！请参考：【code:TaskViewTab】");
		this.setTaskName(item.getItemName());
		this.setButtonSet(item.getAttribute1());
		this.setButtons(item.getAttribute2());
		this.setViewTabSet(item.getAttribute3());
		this.setViewTabs(item.getAttribute4());
		this.setRequiredViewTabs(item.getAttribute5());
	}
	
	/**
	 * 初始化需要展示的按钮的相关属性
	 * @throws Exception
	 */
	private void initButtonItemList() throws Exception{
		this.buttonItemList = TaskViewTabService.initButtonItemList(this.buttonSet, this.buttons);
	}
	
	/**
	 * 初始化需要展示的tab的相关属性
	 * @throws Exception
	 */
	private void initViewTabItemList() throws Exception{
		this.viewTabItemList = TaskViewTabService.initViewTabList(viewTabSet, viewTabs);
		//如果tab为重点标示项，展示时名称前加上红色'*'
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
	 * 增加需要展示的按钮
	 * @param buttonItem
	 */
	public void addButtonItem(Button buttonItem) {
		this.buttonItemList.add(buttonItem);
	}
	
	/**
	 * 增加需要展示的tab
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
