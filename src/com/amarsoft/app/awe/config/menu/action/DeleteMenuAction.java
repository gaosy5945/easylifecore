package com.amarsoft.app.awe.config.menu.action;

import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * 主菜单删除处理，删除菜单记录的同时删除其与所属子系统、可见角色的关联关系
 * @author xhgao
 *
 */
public class DeleteMenuAction {

	//定义变量
	private String menuID; //菜单编号

	public String getMenuID() {
		return menuID;
	}

	public void setMenuID(String menuID) {
		this.menuID = menuID;
	}

	public String deleteMenuAndRela(JBOTransaction tx) throws Exception{
		
		DeleteMenuRela delMenuRela = new DeleteMenuRela();
		delMenuRela.setMenuID(menuID);
		
		//删除指定菜单与所属子系统的关联关系
		//delMenuRela.deleteMenuApps(Sqlca);
		//删除指定菜单与可见角色的关联关系
		delMenuRela.deleteMenuRoles(tx);
		
		//删除指定菜单信息
		JBOFactory.getBizObjectManager("jbo.awe.AWE_MENU_INFO",tx)
		.createQuery("delete from  O where MenuID = :MenuID")
		.setParameter("MenuID", menuID)
		.executeUpdate();
 		
		return "SUCCEEDED";
	}
}
