package com.amarsoft.app.awe.config.menu.action;

import java.text.DecimalFormat;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * 快捷菜单删除、排序功能
 * @author M·Winter
 *
 */
public class QuickHrefAction {

	private String quickId; // 快捷菜单编号
	
	/**
	 * 设置快捷菜单编号
	 * RunJavaMethod参数QuickId=***将会调用到
	 * @param quickId
	 */
	public void setQuickId(String quickId) {
		this.quickId = quickId;
	}
	
	/**
	 * 删除快捷菜单，删除主键由{@link #setQuickId(String)}得到
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
			return "删除数据异常！";
		}
		
		return "SUCCESS";
	}
	
	private DecimalFormat format = new DecimalFormat("0000"); // 排序号格式化长度
	
	/**
	 * 排序快捷菜单，排序顺序由{@link #setQuickId(String)}设置的字符串(以@符号分隔)自然顺序获取
	 * @param tx
	 * @return
	 */
	public String saveSort(JBOTransaction tx){
		if(quickId == null) return "数据传递异常！";
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
				return "保存排序异常！";
			}
		}
		return "保存成功！";
	}
	
}
