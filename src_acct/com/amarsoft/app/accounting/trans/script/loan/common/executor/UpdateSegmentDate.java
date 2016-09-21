package com.amarsoft.app.accounting.trans.script.loan.common.executor;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.script.ScriptConfig;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.lang.StringX;

/**
 * 表内贷款发放，创建ACCT_LOAN对象
 * 
 */
public class UpdateSegmentDate extends TransactionProcedure {
	
	@Override
	public int run() throws Exception {
		String segmentType=TransactionConfig.getScriptConfig(transactionCode, scriptID, "SegmentType");
		String segmentFilter=TransactionConfig.getScriptConfig(transactionCode, scriptID, "SegmentFilter");
		String stepUnit=DateHelper.TERM_UNIT_MONTH;
		int step=1;
		String firstFromDate=TransactionConfig.getScriptConfig(transactionCode, scriptID, "FromDateAttribute");
		firstFromDate=(String)ScriptConfig.executeELScript(firstFromDate, "transaction",this.transaction);
		
		List<BusinessObject> segmentList = this.relativeObject.getBusinessObjectsBySql(segmentType, segmentFilter);
		for (int i=0;i<segmentList.size();i++) {
			BusinessObject segment=segmentList.get(i);
			
			String segFromDate = segment.getString("SegFromDate");// 区段起始日期
			int segFromStage = segment.getInt("SEGFromStage");// 区段起始期次
			int segStages = segment.getInt("SEGStages");// 持续期次
			String segToDate = segment.getString("SegToDate");// 区段结束日期
			int segToStage = segment.getInt("SEGToStage");// 区段结束期次

			if(StringX.isEmpty(segFromDate)){
				if (segFromStage >0) {//有起始月数的话，那么累加
					segFromDate = DateHelper.getRelativeDate(firstFromDate, stepUnit, (segFromStage - 1) * step);// 此处需要减一，因为录入时用户习惯从1开始
				}
				else{
					segFromDate=firstFromDate;
				}
			}
			
			if(StringX.isEmpty(segToDate)){
				if (segToStage>0) {//有起始月数的话，那么累加
					segToDate = DateHelper.getRelativeDate(firstFromDate, stepUnit, (segToStage - 1) * step);// 此处需要减一，因为录入时用户习惯从1开始
				}
				else if (segStages>0){
					segToDate = DateHelper.getRelativeDate(segFromDate, stepUnit, (segToStage - 1) * step);
				}
			}
			segment.setAttributeValue("SegFromDate", segFromDate);
			segment.setAttributeValue("SegToDate", segToDate);
			this.bomanager.updateBusinessObject(segment);
		}
		return 1;
	}

	public void updateSegmentsDate(String orginalFromDate,List<BusinessObject> segmentList,String stepUnit,int step) throws Exception{
		for (int i=0;i<segmentList.size();i++) {
			BusinessObject segment=segmentList.get(i);
			
			String segFromDate = segment.getString("SegFromDate");// 区段起始日期
			int segFromStage = segment.getInt("SEGFromStage");// 区段起始期次
			int segStages = segment.getInt("SEGStages");// 持续期次
			String segToDate = segment.getString("SegToDate");// 区段结束日期
			int segToStage = segment.getInt("SEGToStage");// 区段结束期次

			if(StringX.isEmpty(segFromDate)){
				if (segFromStage >0) {//有起始月数的话，那么累加
					segFromDate = DateHelper.getRelativeDate(orginalFromDate, stepUnit, (segFromStage - 1) * step);// 此处需要减一，因为录入时用户习惯从1开始
				}
				else{
					segFromDate=orginalFromDate;
				}
			}
			
			if(StringX.isEmpty(segToDate)){
				if (segToStage>0) {//有起始月数的话，那么累加
					segToDate = DateHelper.getRelativeDate(orginalFromDate, stepUnit, (segToStage - 1) * step);// 此处需要减一，因为录入时用户习惯从1开始
				}
				else if (segStages>0){
					segToDate = DateHelper.getRelativeDate(segFromDate, stepUnit, (segToStage - 1) * step);
				}
			}
			segment.setAttributeValue("SegFromDate", segFromDate);
			segment.setAttributeValue("SegToDate", segToDate);
			this.bomanager.updateBusinessObject(segment);
		}
	}

}
