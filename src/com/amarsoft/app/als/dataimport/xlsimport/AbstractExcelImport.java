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
 *�Զ��巽��
 *<li>execel �����ṩ���ַ���
 *<li>��һ�ֲ��Զ��嵼�뷽�������������õģʣ£ϵ��뵽������
 *<li>�ڶ��ַ����Զ����˵��뷽�����Զ��巽����Ҫ�̳и��࣬���ཫ���ݴ����process ���������ж����������ɼ�顢���¡��������
 *<li>ʵ���ɼ�ר��������ú͵���
 * @author cjyu 
 * @since  2012-8-16 ����09:14:15
 */
public abstract class AbstractExcelImport {

	protected   ASUser CurUser;//�����û�
	private   Page CurPage; //ҳ�����

	private StringBuffer logBuffer=new StringBuffer();//��־
	protected MineImportManager manger;
	private boolean isForFlag = true;//�������һ���������֤��ͨ�����Ƿ����ִ�У����ڴ����ݵ�����������Ӱ�����ܣ�
	/**
	 * ���ݵ��뿪ʼ�����˴����������������йص�����Ӧ���ڴ˴�����
	 * @param tx
	 * @since  2012-8-16 ����09:57:14
	 */
	public abstract void start(JBOTransaction tx);
	/**
	 * ���ݴ�����̣�������һ���еĴ��뵽�÷����У�
	 * <li>����jbo.excelimport.xml�ж����˸�ʽ����ͨ��jbo��Name��ö�Ӧ������
	 * <li>����jbo_excelimport.xmlδ������и�ʽ����ֻͨ���������ҵ�������
	 * <li>����xml �ļ��ж�����  
	 * </br> &lt;attribute name="MANAGEUSERID" label="�ܻ���" type="String" length="6"&gt;
	 * </br>   	  &lt;extendProperties"&gt;
	 * </br>						&lt;property name="excelCol" value="D" /"&gt;
	 * </br>��D�п�ͨ��excelMap.get("MANAGEUSERID")���
	 * @param excelMap
	 * @return
	 * @since  2012-8-16 ����09:52:49
	 */
	public abstract boolean process(Map<String,DataElement> excelMap);
	/**
	 * ����Excel�Ľ����׶Σ�Excel�������ʱ���ø÷���
	 * 
	 * @since  2012-8-16 ����09:51:57
	 */
	public abstract void end();

	/**
	 * ���õ�ǰ�û�
	 * @param curUser
	 * @since  2012-8-16 ����09:51:20
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
	 * ����ҳ�棬��ͨ����ҳ���ô���Ĳ���
	 * @param curPage
	 * @since  2012-8-16 ����09:50:51
	 */
	public void setCurPage(Page curPage) {
		this.CurPage = curPage;
	}
	/**
	 * д�뵼�������־
	 * @param slog
	 * @since  2012-8-16 ����09:50:28
	 */
	public void writeLog(String slog)
	{
		logBuffer.append(slog+"</br>");
	}
	/**
	 * ����Manager�࣬��ͨ��Manger�ҵ������Լ���Ҫ�Ĳ���
	 * @param m
	 * @since  2012-8-16 ����10:02:02
	 */
	public void setManager(MineImportManager m)
	{
		  manger=m;
	}
	/**
	 * ���CurPage�еĲ���
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
	 * ���������־
	 * @return
	 * @since  2012-8-16 ����10:07:27
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