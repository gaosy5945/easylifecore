package com.amarsoft.app.awe.config.menu.action;

import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * ���û�ͣ�����˵���Ŀ
 * 			MenuID: ��Ŀ���
 * 			Flag�����û���ͣ�ñ�־  ���� 1;ͣ�� 2;
 */
public class ChangeMenuState{

	private String menuID; //��Ŀ���
	private String sortNo; //�����
	private String flag; //��־
	private String includeSubs; //�Ƿ�������²˵�
	
	public String getMenuID() {
		return menuID;
	}

	public void setMenuID(String menuID) {
		this.menuID = menuID;
	}

	public String getSortNo() {
		return sortNo;
	}

	public void setSortNo(String sortNo) {
		this.sortNo = sortNo;
	}

	public String getFlag() {
		return flag;
	}

	public void setFlag(String flag) {
		this.flag = flag;
	}

	public String getIncludeSubs() {
		return includeSubs;
	}

	public void setIncludeSubs(String includeSubs) {
		this.includeSubs = includeSubs;
	}

	/**
	 * ���û�ͣ�����˵���Ŀ
	 * @param tx
	 * @return	sReturn��������ʾ
	 * @throws Exception
	 */
	public String changeMenuState(JBOTransaction tx) throws Exception {
		String isInUse = "";
		if("1".equals(flag)){
			isInUse = "1";
		}else if("2".equals(flag)){
			isInUse = "2";
		}else{ // ״̬����ͣ�ú����ã���ô����
			isInUse = "0";
		}
		
		//ͬʱ�������²˵�
		if("true".equals(includeSubs)){
			JBOFactory.getBizObjectManager("jbo.awe.AWE_MENU_INFO",tx)
			.createQuery("update O set IsInUse=:IsInUse where SortNo like :SortNo")
			.setParameter("IsInUse",isInUse).setParameter("SortNo",sortNo+"%")
			.executeUpdate();
 		}else{
 			JBOFactory.getBizObjectManager("jbo.awe.AWE_MENU_INFO",tx)
			.createQuery("update O set IsInUse=:IsInUse where MenuID = :MenuID")
			.setParameter("IsInUse",isInUse).setParameter("MenuID",menuID)
			.executeUpdate();
		}
		
		return "SUCCEEDED";
	}
}
