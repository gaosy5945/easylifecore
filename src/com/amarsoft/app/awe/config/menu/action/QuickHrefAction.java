package com.amarsoft.app.awe.config.menu.action;

import java.text.DecimalFormat;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * ��ݲ˵�ɾ����������
 * @author M��Winter
 *
 */
public class QuickHrefAction {

	private String quickId; // ��ݲ˵����
	
	/**
	 * ���ÿ�ݲ˵����
	 * RunJavaMethod����QuickId=***������õ�
	 * @param quickId
	 */
	public void setQuickId(String quickId) {
		this.quickId = quickId;
	}
	
	/**
	 * ɾ����ݲ˵���ɾ��������{@link #setQuickId(String)}�õ�
	 * @param tx
	 * @return
	 */
	public String deleteQuick(JBOTransaction tx){
		try {
			JBOFactory.getBizObjectManager("jbo.awe.AWE_QUICK_HREF",tx)
			.createQuery("delete from O where QuickId = :QuickId")
 			.setParameter("QuickId", quickId)
			.executeUpdate();
		} catch (Exception e) {
			ARE.getLog().debug(e);
			return "ɾ�������쳣��";
		}
		
		return "SUCCESS";
	}
	
	private DecimalFormat format = new DecimalFormat("0000"); // ����Ÿ�ʽ������
	
	/**
	 * �����ݲ˵�������˳����{@link #setQuickId(String)}���õ��ַ���(��@���ŷָ�)��Ȼ˳���ȡ
	 * @param tx
	 * @return
	 */
	public String saveSort(JBOTransaction tx){
		if(quickId == null) return "���ݴ����쳣��";
		String[] sQuicks = quickId.split("@");
		for(int i = 0; i < sQuicks.length; i++){
			try {
				JBOFactory.getBizObjectManager("jbo.awe.AWE_QUICK_HREF",tx)
				.createQuery("update O set SortNo = :SortNo where QuickId = :QuickId")
				.setParameter("SortNo", format.format(i))
				.setParameter("QuickId", sQuicks[i])
				.executeUpdate();
			} catch (Exception e) {
				ARE.getLog().debug(e);
				return "���������쳣��";
			}
		}
		return "����ɹ���";
	}
	
}
