package com.amarsoft.app.awe.config.role.action;

import java.util.ArrayList;
import java.util.List;
import java.util.SortedSet;
import java.util.TreeSet;

import com.amarsoft.app.als.awe.script.WebBusinessProcessor;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.StringHelper;
import com.amarsoft.app.als.businessobject.action.BusinessObjectFactory;
import com.amarsoft.app.als.sys.function.config.SysFunctionCache;
import com.amarsoft.app.util.ReloadCacheConfigAction;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.Element;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.json.JSONObject;
import com.amarsoft.awe.res.model.MenuItem;
import com.amarsoft.awe.res.model.comparators.MenuItemComparator;
import com.amarsoft.context.ASUser;
import com.amarsoft.dict.als.cache.AWEMenuCache;
import com.amarsoft.web.ui.mainmenu.AmarMenu;

/**
 * 主菜单,树图对角色授权处理
 * @author jqliang  2015-03-25
 *
 */
public class RoleManager extends WebBusinessProcessor{
	
	public AmarMenu getMenu(ASUser curUser) throws Exception{
		ArrayList<MenuItem> menuItemList = new ArrayList<MenuItem>();
	    SortedSet<MenuItem> menuSet = new TreeSet<MenuItem>(new MenuItemComparator());
	    ArrayList<String> roleIdList = curUser.getRoleTable();
	    for (String roleID : roleIdList) {
	    	List<BusinessObject> roleMenuList = SysFunctionCache.getRoleMenus(roleID);
	    	for (BusinessObject roleMenu : roleMenuList) {
	    		String orgLevel=roleMenu.getString("OrgLevel");
	    		if(StringX.isEmpty(orgLevel)||StringHelper.contains(orgLevel, curUser.getOrgLevel())){
	    			MenuItem menuItem = AWEMenuCache.getMenuItem(roleMenu.getString("MenuID"));
	    			if(menuItem!=null) menuSet.add(menuItem);
	    		}
	    	}
	    }
	    menuItemList.addAll(menuSet);
	    AmarMenu menu = new AmarMenu(menuItemList);
		//menu.initMenu(menuItemList);
		return menu;
	}
	
	/**
	 * 将选择的树图节点的权限赋给对应的机构级别的角色(机构级别为空则所有机构级别都没有权限)
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public String updateRoleRight(JBOTransaction tx) throws Exception{
		this.setTx(tx);
		BusinessObjectManager bomanager = getBusinessObjectManager();
		
		JSONObject changedData=(JSONObject)this.inputParameter.getValue("ChangedData");
		String roleID=(String)this.inputParameter.getValue("RoleID");
		
		for(int i=0;i<changedData.size();i++){
			Element menuElement = changedData.get(i);
			String menuID = menuElement.getName();

			JSONObject functions = (JSONObject)menuElement.getValue();
			for(int j=0;j<functions.size();j++){
				Element functionElement = functions.get(j);
				String rightString = (String)functionElement.getValue();
				String newRoleRightString="";
				
				BusinessObject functionItem=BusinessObjectFactory.loadSingle("jbo.sys.SYS_FUNCTION_LIBRARY", functionElement.getName(), bomanager);
				String roleRightString = functionItem.getString("RoleRightType");
				if(!StringX.isEmpty(roleRightString)){
					String[] roleRightArray=roleRightString.split(",");
					for(String roleRight:roleRightArray){
						String[] s = roleRight.split("\\$");
						if(roleID.equals(s[0])) continue;
						newRoleRightString+=","+roleRight;
					}
				}
				if(!StringX.isEmpty(rightString))
					newRoleRightString+=","+roleID+"$"+rightString;
				if(!StringX.isEmpty(newRoleRightString)&&newRoleRightString.startsWith(","))
					newRoleRightString=newRoleRightString.substring(1);
				functionItem.setAttributeValue("RoleRightType", newRoleRightString);
				bomanager.updateBusinessObject(functionItem);
			}
			bomanager.updateDB();
			
			BusinessObject menu=BusinessObjectFactory.loadSingle("jbo.awe.AWE_MENU_INFO", menuID, bomanager);
			String menuFunctionID = menu.getString("URLParam");
			if(StringX.isEmpty(menuFunctionID)) continue;
			menuFunctionID=StringHelper.replaceAllIgnoreCase(menuFunctionID, "SYS_FUNCTIONID=", "");
			List<BusinessObject> functionItemList = bomanager.loadBusinessObjects("jbo.sys.SYS_FUNCTION_LIBRARY", "FunctionID=:FunctionID and IsInUse='1' "
					+ "and (RoleRightType like :RoleRightType and RightID='1' or RightID is null or RightID='2') order by FunctionID,SortNo ","FunctionID",menuFunctionID,"RoleRightType","%"+roleID+"%");
			if(functionItemList==null||functionItemList.isEmpty()){
				bomanager.deleteBusinessObjects(bomanager.loadBusinessObjects("jbo.awe.AWE_ROLE_MENU", "MenuID=:MenuID and RoleID=:RoleID","MenuID",menuID,"RoleID",roleID));
			}
			else{
				String orgLevel="";
				TreeSet<String> orgLevelSet= new TreeSet<String>();
				for(BusinessObject functionItem:functionItemList){
					String roleRightString = functionItem.getString("RoleRightType");
					if(StringX.isEmpty(roleRightString)){
						orgLevel="All";
						
					}
					String[] roleRightArray=roleRightString.split(",");
					for(String roleRight:roleRightArray){
						String[] s = roleRight.split("\\$");
						if(!roleID.equals(s[0])) continue;
						if(s.length==1||StringX.isEmpty(s[1])){
							orgLevel="All";
							break;
						}
						String[] orgLevelItemArray=s[1].split("@");
						for(String orgLevelItem:orgLevelItemArray){
							if(!orgLevelSet.contains(orgLevelItem)){
								orgLevelSet.add(orgLevelItem);
							}
						}
					}
					if(orgLevel.equals("All")){
						break;
					}
				}
				
				BusinessObject roleMenu = null;
				List<BusinessObject> menuRoleList= bomanager.loadBusinessObjects("jbo.awe.AWE_ROLE_MENU", "MenuID=:menuID and RoleID=:roleID","MenuID",menuID,"RoleID",roleID);
				if(menuRoleList==null||menuRoleList.isEmpty()){
					roleMenu=BusinessObject.createBusinessObject("jbo.awe.AWE_ROLE_MENU");
					roleMenu.setAttributeValue("MenuID", menuID);
					roleMenu.setAttributeValue("RoleID", roleID);
				}
				else{
					roleMenu = menuRoleList.get(0);
				}
				
				if(!orgLevel.equals("All")){
					for(String s:orgLevelSet){
						orgLevel+=","+s;
					}
					orgLevel=orgLevel.substring(1);
				}
				else{
					orgLevel="";
				}
				roleMenu.setAttributeValue("OrgLevel", orgLevel);
				bomanager.updateBusinessObject(roleMenu);
			}
			bomanager.updateDB();
		}
		bomanager.commit();
		ReloadCacheConfigAction cache=new ReloadCacheConfigAction();
		cache.setConfigName("角色");
		cache.reloadCache();
		
		cache.setConfigName("系统功能定义缓存");
		cache.reloadCache();
		return "SUCCEEDED";
	}
}
