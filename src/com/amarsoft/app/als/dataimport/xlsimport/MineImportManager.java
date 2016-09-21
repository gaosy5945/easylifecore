package com.amarsoft.app.als.dataimport.xlsimport;

import java.util.List;
import java.util.Map;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObjectClass;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DataElement;

/**
 * @author cjyu 
 * @since  2012-8-15 ����08:28:35
 */
public class MineImportManager  extends ExcelImportManager{
	private String startAddress = "A1";				//��ʼ��ַ
	private String finishAddress = "Z1000";			//������ַ
	private String RelativeSerialNo = "";		
	/**
	 * ��ȡ��ʼ��ַ
	 * @return
	 */
	public String getStartAddress() {
		return startAddress;
	}
	/**
	 * ���ÿ�ʼ��ַ
	 * @param startAddress
	 */
	public void setStartAddress(String startAddress) {
		this.startAddress = startAddress;
	}
	/**
	 * ��ȡ������ַ
	 * @return
	 */
	public String getFinishAddress() {
		return finishAddress;
	}
	/**
	 * ���ý�����ַ
	 * @param finishAddress
	 */
	public void setFinishAddress(String finishAddress) {
		this.finishAddress = finishAddress;
	}
	/**
	 * ���ù�����ˮ
	 */
	public void setRelativeSerialNo(String sRelativeSerialNo)
	{
		RelativeSerialNo=sRelativeSerialNo;
	}
	/**
	 * ʵ�ָ���
	 * @see com.amarsoft.proj.nbcb.dataimport.ExcelImportManager#executeImport()
	 */
	@Override
	public void executeImport() throws DataImportException {
	 
		DataGridReader dataGridReader;
		
		try {
			dataGridReader = new DataGridReader(getInputStream(),0);
			dataGridReader.setStartAddress(startAddress);
			dataGridReader.setFinishAddress(finishAddress);
			BizObjectClass jboClass=this.getManagedClass();
			dataGridReader.setJboClass(jboClass);
			dataGridReader.loadSheet();
			Map<String,DataElement> map = dataGridReader.getDataMap();  
			List<Map<String,DataElement>>  lst=dataGridReader.getExcelList();
			if(this.getImportClass()!=null) mineImport(lst);
			else  gridWrite(map);
		} catch (Exception e) { 
			ARE.getLog().error("�����ļ�����",e);
			throw new DataImportException("�����ļ�����",e);
		} 
	}
	
	
	
	/**
	 * ͨ��JBO�ĵ���
	 * @param map
	 * @throws WriteException
	 * @since  2012-8-16 ����09:41:46
	 */
	private void gridWrite(Map<String,DataElement> map ) throws WriteException
	{
		DataGridWriter dataGridWriter = new DataGridWriter(this,this.getManagedClass());
		int startRowIndex = ExcelReader.getRowIndex(startAddress);
		int finishRowIndex = ExcelReader.getRowIndex(finishAddress);
		dataGridWriter.setStartRowIndex(startRowIndex);
		dataGridWriter.setFinishRowIndex(finishRowIndex);
		dataGridWriter.write(map);
	}
	
	/**
	 * �Զ��嵼��ķ���
	 * @param lst
	 * @throws Exception
	 * @since  2012-8-16 ����09:39:34
	 */
	private void mineImport(List<Map<String,DataElement>>  lst) throws Exception
	{
		//�Զ���Ĵ�����
		 JBOTransaction tx=null;
		 try{
			 AbstractExcelImport aei=(AbstractExcelImport)Class.forName(this.getImportClass()).newInstance();
			 aei.setCurPage(getCurPage());
			 aei.setCurUser(getCurUser());
			 aei.setManager(this);
			 tx=JBOFactory.createJBOTransaction();
			 aei.start(tx);
			for(Map<String,DataElement> map2:lst)
			{
				if(map2.size()==0) continue;
				if(!aei.isForFlag())continue;
 				if(aei.process(map2)) this.sucessNum++;
 				else this.failNum++;
			}
			aei.end();
			writeLog(aei.getLog());
			if(tx!=null)tx.commit(); 
		 }catch(Exception e)
		 {
			 try{
				 if(tx!=null) tx.rollback(); 
			 }catch(JBOException ex)
			 {
				 ex.printStackTrace();
			 } 
			 writeLog("��������ʱʧ��["+e.getMessage()+"]");
			 e.printStackTrace();
		 } 
	}
	

}
