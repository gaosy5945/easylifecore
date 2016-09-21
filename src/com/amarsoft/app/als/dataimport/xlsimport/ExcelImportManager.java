 package com.amarsoft.app.als.dataimport.xlsimport;

import java.io.InputStream;

import com.amarsoft.are.jbo.impl.ALSBizObjectManager;
import com.amarsoft.awe.control.model.Page;
import com.amarsoft.context.ASUser;


/**
 * @author syang
 * @date 2011-7-21
 * @describe Excel���ݵ���JBO������,��Manager�ṩ��ҵ������ã����ṩ����������
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
	public int sucessNum=0;//����ɹ�����
	public int failNum=0;//ʧ�ܱ���
	public StringBuffer log=new StringBuffer();//ִ����־
	private String excelPath="";
	
	/**
	 * ��ȡ��ȡsheetҳ������
	 * @return
	 */
	public int getSheetIndex() {
		return sheetIndex;
	}
	/**
	 * ���ö�ȡsheetҳ������
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
	 * ����ҳ�������Ϣ
	 * @return
	 */
	public Page getCurPage() {
		return curPage;
	}
	/**
	 * ���ҳ�������Ϣ
	 * @return
	 */
	public void setCurPage(Page curPage) {
		this.curPage = curPage;
	}
	
	public abstract void executeImport() throws DataImportException ;
	/**
	 * ���õ����Class����
	 * @param importClass
	 * @since  2012-8-16 ����09:21:19
	 */
	public void setImportClass(String importClass) {
		this.importClass = importClass;
	}
	/**
	 * ��õ����Class����
	 * @return
	 * @since  2012-8-16 ����09:20:59
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
			slog="������� </br>"+
				this.log.toString();
		}else if(this.sucessNum==0&&this.failNum!=0){
			slog="������� :����ɹ�:"+this.sucessNum+" ����ʧ�� "+this.failNum+" ��</br>������������ ,�����µ���</br>"+
					 this.log.toString();
		}else{
			slog="������� :����ɹ�:"+this.sucessNum+" ����ʧ�� "+this.failNum+" ��</br>"+
				 this.log.toString();
		}
		return slog;
	}
	/**
	 * д����־
	 * @param slog
	 * @since  2012-8-16 ����10:06:35
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
