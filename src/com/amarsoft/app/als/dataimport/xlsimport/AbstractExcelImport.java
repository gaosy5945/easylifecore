package com.amarsoft.app.als.dataimport.xlsimport;

import java.util.Map;
import java.util.Vector;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.awe.control.model.Page;
import com.amarsoft.awe.control.model.Parameter;
import com.amarsoft.context.ASUser;

/**
 *自定义方法
 *<li>execel 导入提供两种方法
 *<li>第一种不自定义导入方法，将根据配置的ＪＢＯ导入到单表中
 *<li>第二种方法自定义了导入方法，自定义方法需要继承该类，该类将数据传入给process 方法，由有定义的类中完成检查、更新、导入操作
 *<li>实例可见专项检查的配置和导入
 * @author cjyu 
 * @since  2012-8-16 上午09:14:15
 */
public abstract class AbstractExcelImport {

	protected   ASUser CurUser;//导入用户
	private   Page CurPage; //页面参数

	private StringBuffer logBuffer=new StringBuffer();//日志
	protected MineImportManager manger;
	private boolean isForFlag = true;//如果发生一条报错或验证不通过，是否继续执行（用于大数据的跳出，否则影响性能）
	/**
	 * 数据导入开始处理，此处传入了事务，事务有关的事情应该在此处增加
	 * @param tx
	 * @since  2012-8-16 上午09:57:14
	 */
	public abstract void start(JBOTransaction tx);
	/**
	 * 数据处理过程，将数据一行行的传入到该方法中，
	 * <li>如在jbo.excelimport.xml中定义了格式，可通过jbo的Name获得对应的数据
	 * <li>如在jbo_excelimport.xml未定义该行格式，则只通过行名称找到该数据
	 * <li>如在xml 文件中定义了  
	 * </br> &lt;attribute name="MANAGEUSERID" label="管户人" type="String" length="6"&gt;
	 * </br>   	  &lt;extendProperties"&gt;
	 * </br>						&lt;property name="excelCol" value="D" /"&gt;
	 * </br>则D行可通过excelMap.get("MANAGEUSERID")获得
	 * @param excelMap
	 * @return
	 * @since  2012-8-16 上午09:52:49
	 */
	public abstract boolean process(Map<String,DataElement> excelMap);
	/**
	 * 导入Excel的结束阶段，Excel导入完成时调用该方法
	 * 
	 * @since  2012-8-16 上午09:51:57
	 */
	public abstract void end();

	/**
	 * 设置当前用户
	 * @param curUser
	 * @since  2012-8-16 上午09:51:20
	 */
	public void setCurUser(ASUser curUser) {
		this.CurUser = curUser;
	}
	public ASUser getCurUser() {
		return this.CurUser;
	}
	public Page getCurPage() {
		return this.CurPage;
	}
	/**
	 * 设置页面，可通过该页面获得传入的参数
	 * @param curPage
	 * @since  2012-8-16 上午09:50:51
	 */
	public void setCurPage(Page curPage) {
		this.CurPage = curPage;
	}
	/**
	 * 写入导入过程日志
	 * @param slog
	 * @since  2012-8-16 上午09:50:28
	 */
	public void writeLog(String slog)
	{
		logBuffer.append(slog+"</br>");
	}
	/**
	 * 导入Manager类，可通过Manger找到更多自己需要的参数
	 * @param m
	 * @since  2012-8-16 上午10:02:02
	 */
	public void setManager(MineImportManager m)
	{
		  manger=m;
	}
	/**
	 * 获得CurPage中的参数
	 * @param sParameterName
	 * @return
	 */
	public String getParameter(String sParameterName)
	{
		Vector<Parameter> vlst=CurPage.getParameterList();
		for(int i=0;i<vlst.size();i++)
		{
			Parameter p=vlst.get(i);
			String sParaName=p.paraName.trim();
			ARE.getLog().info(sParaName+":"+p.paraValue);
			if(sParaName.equalsIgnoreCase(sParameterName)) {
				
				return p.paraValue;
			}
		}
		return "";
	}
	/**
	 * 获得运行日志
	 * @return
	 * @since  2012-8-16 上午10:07:27
	 */
	public String getLog()
	{
		return this.logBuffer.toString();
	}
	public void setForFlag(boolean isForFlag) {
		this.isForFlag = isForFlag;
	}
	public boolean isForFlag() {
		return isForFlag;
	}	 
}