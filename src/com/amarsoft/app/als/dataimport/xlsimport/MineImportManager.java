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
 * @since  2012-8-15 下午08:28:35
 */
public class MineImportManager  extends ExcelImportManager{
	private String startAddress = "A1";				//开始地址
	private String finishAddress = "Z1000";			//结束地址
	private String RelativeSerialNo = "";		
	/**
	 * 获取开始地址
	 * @return
	 */
	public String getStartAddress() {
		return startAddress;
	}
	/**
	 * 设置开始地址
	 * @param startAddress
	 */
	public void setStartAddress(String startAddress) {
		this.startAddress = startAddress;
	}
	/**
	 * 获取结束地址
	 * @return
	 */
	public String getFinishAddress() {
		return finishAddress;
	}
	/**
	 * 设置结束地址
	 * @param finishAddress
	 */
	public void setFinishAddress(String finishAddress) {
		this.finishAddress = finishAddress;
	}
	/**
	 * 设置关联流水
	 */
	public void setRelativeSerialNo(String sRelativeSerialNo)
	{
		RelativeSerialNo=sRelativeSerialNo;
	}
	/**
	 * 实现父类
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
			ARE.getLog().error("解析文件出错",e);
			throw new DataImportException("解析文件出错",e);
		} 
	}
	
	
	
	/**
	 * 通过JBO的导入
	 * @param map
	 * @throws WriteException
	 * @since  2012-8-16 上午09:41:46
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
	 * 自定义导入的方法
	 * @param lst
	 * @throws Exception
	 * @since  2012-8-16 上午09:39:34
	 */
	private void mineImport(List<Map<String,DataElement>>  lst) throws Exception
	{
		//自定义的处理方法
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
			 writeLog("导入数据时失败["+e.getMessage()+"]");
			 e.printStackTrace();
		 } 
	}
	

}
