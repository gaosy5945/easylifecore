 package com.amarsoft.app.als.dataimport.xlsimport;

import java.io.InputStream;

import com.amarsoft.are.jbo.impl.ALSBizObjectManager;
import com.amarsoft.awe.control.model.Page;
import com.amarsoft.context.ASUser;


/**
 * @author syang
 * @date 2011-7-21
 * @describe Excel数据导入JBO管理器,该Manager提供给业务处理调用，不提供给批量调用
 */
public abstract class ExcelImportManager extends ALSBizObjectManager{
	
	private int sheetIndex = 0;
	private InputStream inputStream = null;
	private ASUser curUser = null;
	private String orgField = null;
	private String userField = null;
	private String dateField = null;
	private Page curPage;
	private String importClass=null;
	public int sucessNum=0;//导入成功笔数
	public int failNum=0;//失败笔数
	public StringBuffer log=new StringBuffer();//执行日志
	private String excelPath="";
	
	/**
	 * 获取读取sheet页索引号
	 * @return
	 */
	public int getSheetIndex() {
		return sheetIndex;
	}
	/**
	 * 设置读取sheet页索引号
	 * @param sheetIndex
	 */
	public void setSheetIndex(int sheetIndex) {
		this.sheetIndex = sheetIndex;
	}
	
	public InputStream getInputStream() {
		return inputStream;
	}
	public void setInputStream(InputStream inputStream) {
		this.inputStream = inputStream;
	}
	
	public ASUser getCurUser() {
		return curUser;
	}
	public void setCurUser(ASUser curUser) {
		this.curUser = curUser;
	}
	public String getOrgField() {
		return orgField;
	}
	public void setOrgField(String orgField) {
		this.orgField = orgField;
	}
	public String getUserField() {
		return userField;
	}
	public void setUserField(String userField) {
		this.userField = userField;
	}
	
	public String getDateField() {
		return dateField;
	}
	public void setDateField(String dateField) {
		this.dateField = dateField;
	}
	
	/**
	 * 设置页面参数信息
	 * @return
	 */
	public Page getCurPage() {
		return curPage;
	}
	/**
	 * 获得页面参数信息
	 * @return
	 */
	public void setCurPage(Page curPage) {
		this.curPage = curPage;
	}
	
	public abstract void executeImport() throws DataImportException ;
	/**
	 * 设置导入的Class类名
	 * @param importClass
	 * @since  2012-8-16 上午09:21:19
	 */
	public void setImportClass(String importClass) {
		this.importClass = importClass;
	}
	/**
	 * 获得导入的Class类名
	 * @return
	 * @since  2012-8-16 上午09:20:59
	 */
	public String getImportClass()
	{
		return this.importClass;
	}

	public String getLog()
	{
		String slog="";
		if(this.sucessNum==0&&this.failNum==0)
		{
			slog="导入完成 </br>"+
				this.log.toString();
		}else if(this.sucessNum==0&&this.failNum!=0){
			slog="导入完成 :导入成功:"+this.sucessNum+" 条，失败 "+this.failNum+" 条</br>导入数据有误 ,请重新导入</br>"+
					 this.log.toString();
		}else{
			slog="导入完成 :导入成功:"+this.sucessNum+" 条，失败 "+this.failNum+" 条</br>"+
				 this.log.toString();
		}
		return slog;
	}
	/**
	 * 写入日志
	 * @param slog
	 * @since  2012-8-16 上午10:06:35
	 */
	protected void writeLog(String slog)
	{
		this.log.append(slog+"</br>");
	}
	public String getExcelPath() {
		return excelPath;
	}
	public void setExcelPath(String excelPath) {
		this.excelPath = excelPath;
	}

}
