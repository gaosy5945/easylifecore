package com.amarsoft.app.als.awe.ow2.htmlgenerator;

import java.util.ArrayList;

import com.amarsoft.app.als.awe.ow2.processor.DataObjectQuerier;
import com.amarsoft.app.als.awe.ow2.processor.OWBusinessProcessor;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.ObjectWindowHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.dw.handler.BusinessProcessData;
import com.amarsoft.awe.dw.ui.htmlfactory.imp.DefaultListHtmlGenerator;

public class ListOWHtmlGenerator extends DefaultListHtmlGenerator {

	public void run(BusinessProcessData bpData) throws Exception {
		try{
			OWBusinessProcessor businessProcess = OWBusinessProcessor.createBusinessProcess(request, this.asObj,BusinessObjectManager.createBusinessObjectManager(this.transaction));
			DataObjectQuerier querier = businessProcess.getQuerier();
			querier.query(businessProcess);
			this.rowCount = querier.getTotalCount();//总记录数
			this.firstRow = (this.curPage * this.pageSize);
			/*if(firstRow>rowCount){
				firstRow=0;
				curPage=0;
			}*/
			BusinessObject[] businessObjectList = querier.getData(firstRow, firstRow+pageSize);
			
			if(businessObjectList==null )this.rowCount=0;
			if (this.rowCount <= 0) this.rowCount = querier.getTotalCount();// businessObjectList.length;
			//计算总页数
			this.pageCount = ((this.rowCount + this.pageSize - 1) / this.pageSize);
	
			this.searchedDataList = new ArrayList<BizObject>();
			if (this.rowCount> 0){
				for(BusinessObject businessObject:businessObjectList){
					this.searchedDataList.add(businessObject);
				}
			}
			if (this.transaction != null){
		        this.transaction.commit();
		    }
		}
		catch(Exception e){
			if (this.transaction != null){
		        this.transaction.rollback();
		    }
			throw e;
		}
	}

	public String getHtmlResult() throws Exception {
		String dwname = ObjectWindowHelper.getObjectWindowName(asObj);
		String html="";
		html +="if(typeof(ALSObjectWindowFunctions)==\"undefined\"||!ALSObjectWindowFunctions){ALSObjectWindowFunctions={};ALSObjectWindowFunctions.objectWindowMetaData=[];ALSObjectWindowFunctions.ObjectWindowData=[];}";
		html += "\n ALSObjectWindowFunctions.objectWindowMetaData["+dwname+"] = "+ObjectWindowHelper.getDWMetaJSONString(asObj)+";\n";
		html += "\n ALSObjectWindowFunctions.ObjectWindowData["+dwname+"] = [];\n";
		for(int i=0;i<this.searchedDataList.size();i++){
			BusinessObject businessObject=(BusinessObject)this.searchedDataList.get(i);
			html += "\n ALSObjectWindowFunctions.ObjectWindowData["+dwname+"]["+i+"] ="+ObjectWindowHelper.generateClientObjectData(asObj,businessObject) +";\n";
		}
		if(!StringX.isEmpty(this.asObj.getDONO())) html += "DisplayDONO='"+this.asObj.getDONO()+"';";
		html+=super.getHtmlResult();
		return html;
	}
	
	
}
