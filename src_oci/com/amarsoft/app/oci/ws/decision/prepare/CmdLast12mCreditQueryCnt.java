package com.amarsoft.app.oci.ws.decision.prepare;


import java.text.ParseException;
import java.util.List;

import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.crqs2.i.bean.IReportMessage;
import com.amarsoft.app.crqs2.i.bean.one.QueryRecord;
import com.amarsoft.app.crqs2.i.bean.three.RecordDetail;
import com.amarsoft.app.crqs2.i.bean.two.RecordInfo;

/**
 * 过去12个月中信贷审核查询次数
 * 
 * @author t-lizp
 * 
 */
public class CmdLast12mCreditQueryCnt implements Command {

	@Override
	public Object execute(IReportMessage message) throws Exception {
		int count = 0;
		QueryRecord queryRecord = message.getQueryRecord();
		if(queryRecord == null) return -9;
		List<RecordInfo> recordInfoList = queryRecord.getRecordInfo();
		if (recordInfoList == null) return count = -9;
		for (RecordInfo recordInfo : recordInfoList) {	
			List<RecordDetail> recordDetailList = recordInfo.getRecordDetail();
			if(recordDetailList == null) continue;
			for(RecordDetail recordDetail:recordDetailList){
				if (!recordDetail.getQueryReason().startsWith(Classification.QUERY_REASON_CREDIT) &&
						!recordDetail.getQueryReason().startsWith(Classification.QUERY_REASON_LOAN))
					continue;
				String date = recordDetail.getQueryDate();
				String year = DateHelper.getBusinessDate().substring(0, 4);
				int inewYear = (Integer.parseInt(year) - 1);
				String snewYear = String.valueOf(inewYear);//获得当前日期前一年的年份
				String queryDate = date.substring(0, 4) + date.substring(5, 7) + date.substring(8, 10);
				String sdate = snewYear + DateHelper.getBusinessDate().substring(5, 7) + DateHelper.getBusinessDate().substring(8, 10);//获得当前日期前12个月的起始日期
				int idate = Integer.parseInt(sdate);
				int iqueryDate = Integer.parseInt(queryDate);
				if (iqueryDate > idate) count = count + 1;	
			}
		}
		return count;
	}
}
