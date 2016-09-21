package com.amarsoft.app.accounting.trans.script.loan.common.executor;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.script.ScriptConfig;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.lang.StringX;

/**
 * ���ڴ���ţ�����ACCT_LOAN����
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
			
			String segFromDate = segment.getString("SegFromDate");// ������ʼ����
			int segFromStage = segment.getInt("SEGFromStage");// ������ʼ�ڴ�
			int segStages = segment.getInt("SEGStages");// �����ڴ�
			String segToDate = segment.getString("SegToDate");// ���ν�������
			int segToStage = segment.getInt("SEGToStage");// ���ν����ڴ�

			if(StringX.isEmpty(segFromDate)){
				if (segFromStage >0) {//����ʼ�����Ļ�����ô�ۼ�
					segFromDate = DateHelper.getRelativeDate(firstFromDate, stepUnit, (segFromStage - 1) * step);// �˴���Ҫ��һ����Ϊ¼��ʱ�û�ϰ�ߴ�1��ʼ
				}
				else{
					segFromDate=firstFromDate;
				}
			}
			
			if(StringX.isEmpty(segToDate)){
				if (segToStage>0) {//����ʼ�����Ļ�����ô�ۼ�
					segToDate = DateHelper.getRelativeDate(firstFromDate, stepUnit, (segToStage - 1) * step);// �˴���Ҫ��һ����Ϊ¼��ʱ�û�ϰ�ߴ�1��ʼ
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
			
			String segFromDate = segment.getString("SegFromDate");// ������ʼ����
			int segFromStage = segment.getInt("SEGFromStage");// ������ʼ�ڴ�
			int segStages = segment.getInt("SEGStages");// �����ڴ�
			String segToDate = segment.getString("SegToDate");// ���ν�������
			int segToStage = segment.getInt("SEGToStage");// ���ν����ڴ�

			if(StringX.isEmpty(segFromDate)){
				if (segFromStage >0) {//����ʼ�����Ļ�����ô�ۼ�
					segFromDate = DateHelper.getRelativeDate(orginalFromDate, stepUnit, (segFromStage - 1) * step);// �˴���Ҫ��һ����Ϊ¼��ʱ�û�ϰ�ߴ�1��ʼ
				}
				else{
					segFromDate=orginalFromDate;
				}
			}
			
			if(StringX.isEmpty(segToDate)){
				if (segToStage>0) {//����ʼ�����Ļ�����ô�ۼ�
					segToDate = DateHelper.getRelativeDate(orginalFromDate, stepUnit, (segToStage - 1) * step);// �˴���Ҫ��һ����Ϊ¼��ʱ�û�ϰ�ߴ�1��ʼ
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
