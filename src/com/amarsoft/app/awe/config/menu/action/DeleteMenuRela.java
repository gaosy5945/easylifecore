package com.amarsoft.app.awe.config.menu.action;

import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * 删除指定菜单与所属子系统、可见角色的关联关系
 *
 */
public class DeleteMenuRela {
	private String menuID; //子系统编号
	
	public String getMenuID() {
		return menuID;
	}

	public void setMenuID(String menuID) {
		this.menuID = menuID;
	}

	/**
	 * 删除指定菜单与所属子系统的关联关系
	 * @return
	 * @throws Exception
	 */
	public String deleteMenuApps(JBOTransaction tx) throws Exception{
		JBOFactory.getBizObjectManager("jbo.awe.AWE_APP_MENU",tx)
		.createQuery("delete from  O where  where MenuID = :MenuID")
		.setParameter("MenuID", menuID)
		.executeUpdate();
  		return "SUCCEEDED";
	}
	
	/**
	 * 删除指定菜单与可见角色的关联关系
	 * @return
	 * @throws Exception
	 */
	public String deleteMenuRoles(JBOTransaction tx) throws Exception{
		JBOFactory.getBizObjectManager("jbo.awe.AWE_ROLE_MENU",tx)
		.createQuery("delete from  O where MenuID = :MenuID")
		.setParameter("MenuID", menuID)
		.executeUpdate();
		return "SUCCEEDED";
	}
}
