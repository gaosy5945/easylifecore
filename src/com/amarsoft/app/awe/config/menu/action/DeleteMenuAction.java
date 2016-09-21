package com.amarsoft.app.awe.config.menu.action;

import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * ���˵�ɾ������ɾ���˵���¼��ͬʱɾ������������ϵͳ���ɼ���ɫ�Ĺ�����ϵ
 * @author xhgao
 *
 */
public class DeleteMenuAction {

	//�������
	private String menuID; //�˵����

	public String getMenuID() {
		return menuID;
	}

	public void setMenuID(String menuID) {
		this.menuID = menuID;
	}

	public String deleteMenuAndRela(JBOTransaction tx) throws Exception{
		
		DeleteMenuRela delMenuRela = new DeleteMenuRela();
		delMenuRela.setMenuID(menuID);
		
		//ɾ��ָ���˵���������ϵͳ�Ĺ�����ϵ
		//delMenuRela.deleteMenuApps(Sqlca);
		//ɾ��ָ���˵���ɼ���ɫ�Ĺ�����ϵ
		delMenuRela.deleteMenuRoles(tx);
		
		//ɾ��ָ���˵���Ϣ
		JBOFactory.getBizObjectManager("jbo.awe.AWE_MENU_INFO",tx)
		.createQuery("delete from  O where MenuID = :MenuID")
		.setParameter("MenuID", menuID)
		.executeUpdate();
 		
		return "SUCCEEDED";
	}
}
