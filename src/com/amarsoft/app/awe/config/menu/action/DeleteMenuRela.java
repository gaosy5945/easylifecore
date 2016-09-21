package com.amarsoft.app.awe.config.menu.action;

import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * ɾ��ָ���˵���������ϵͳ���ɼ���ɫ�Ĺ�����ϵ
 *
 */
public class DeleteMenuRela {
	private String menuID; //��ϵͳ���
	
	public String getMenuID() {
		return menuID;
	}

	public void setMenuID(String menuID) {
		this.menuID = menuID;
	}

	/**
	 * ɾ��ָ���˵���������ϵͳ�Ĺ�����ϵ
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
	 * ɾ��ָ���˵���ɼ���ɫ�Ĺ�����ϵ
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
