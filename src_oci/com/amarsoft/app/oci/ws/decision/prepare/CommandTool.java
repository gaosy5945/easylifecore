package com.amarsoft.app.oci.ws.decision.prepare;

import java.util.Date;
import java.util.List;

import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.crqs2.i.bean.IReportMessage;
import com.amarsoft.app.crqs2.i.bean.four.OverdueRecord;
import com.amarsoft.app.crqs2.i.bean.one.CreditDetail;
import com.amarsoft.app.crqs2.i.bean.three.Latest5YearOverdueRecordParent;
import com.amarsoft.app.crqs2.i.bean.three.PaymentStateParent;
import com.amarsoft.app.crqs2.i.bean.two.Loan;
import com.amarsoft.are.lang.DateX;

/**
 * 征信信息抽取工具类
 * 
 * @author t-liuyc
 * 
 */
public class CommandTool {
	public static List<Loan> getLoanList(IReportMessage message) {
		CreditDetail detail = message.getCreditDetail();
		if (detail == null) return null;
		List<Loan> loanList = detail.getLoan();
		return loanList;
	}

	// 24月还款状态获取逾期总数
	public static int getOverTimeCounts(int mounthNum,PaymentStateParent paymentState) throws Exception {
		int start = getStartPosition(mounthNum, paymentState.getEndMonth());
		int count = 0;
		char[] status = paymentState.getLatest24State().toCharArray();
		for (int i = start; i <= 23; i++) {
			switch (status[i]) {
			case '1':
			case '2':
			case '3':
			case '4':
			case '5':
			case '6':
			case '7':
				count++;
				break;
			default:
				break;
			}
		}
		return count;
	}

	// 24月还款状态获取逾期最大数
	public static int getMaxOverTimeCounts(int mounthNum,PaymentStateParent paymentState) throws Exception{
		int start = getStartPosition(mounthNum, paymentState.getEndMonth());
		int count = 0;
		int temp = 0;
		char[] status = paymentState.getLatest24State().toCharArray();
		for (int i = start; i <= 23; i++) {
			switch (status[i]) {
			case '1':
			case '2':
			case '3':
			case '4':
			case '5':
			case '6':
			case '7':
				temp = Integer.parseInt(status[i] + "");
				if (temp > count) count = temp;
				break;
			default:
				break;
			}
		}
		return count;
	}

	// 最近5年获取逾期总数（最近几个月）
	public static int getOverTimeCounts(int mounthNum,Latest5YearOverdueRecordParent late5Year) throws Exception {
		List<OverdueRecord> recordList = late5Year.getOverdueRecord();
		int result = 0;
//		for (OverdueRecord od : recordList) 
//			result = getMonthCount(mounthNum, od.getMonth(), od.getLastMonths()) + result;
		for(int i=0;i<recordList.size();i++){
			OverdueRecord od = recordList.get(i);
			result = getMonthCount(mounthNum, od.getMonth(), od.getLastMonths()) + result;
		}
		return result;
	}
	
	//最近5年逾期总数（前36个月）
	public static int getOverTimeAheadCount(int monthNum,String paymentBeginMonth,Latest5YearOverdueRecordParent late5Year) throws Exception {
		List<OverdueRecord> recordList = late5Year.getOverdueRecord();
		int result = 0;
		for(int i=0;i<recordList.size();i++){
			OverdueRecord od = recordList.get(i);
			result = getAheadMonthCount(monthNum,paymentBeginMonth,od.getMonth()) + result;
		}
		return result;
	}

	// 最近5年 获取最大逾期数
	public static int getMaxOverTimeCounts(int mounthNum,Latest5YearOverdueRecordParent late5Year) throws Exception {
		List<OverdueRecord> recordList = late5Year.getOverdueRecord();
		int result = 0;
		int temp = 0;
		for (OverdueRecord od : recordList) {
			temp = getMaxMonthCount(mounthNum, od.getMonth(), od.getLastMonths());
			if (temp > result) result = temp;
		}
		return result;
	}

	private static int getStartPosition(int mounthNum, String date) throws Exception{
		String reportMonth = date.substring(5, 7);
		String curdatedate = DateHelper.getBusinessDate();
		String curMonth = (curdatedate.split("/"))[1];
		int start = 0;
		start = 24 - start - mounthNum;
		return start;
	}

	private static int getMaxMonthCount(int mounthNum, String date, String lastMonth) throws Exception {
		int endMonth = convertYToM(date);
		int computeStartMonth = convertYToM(DateHelper.getBusinessDate());
		if (endMonth > computeStartMonth) return new Integer(lastMonth);
		if (computeStartMonth - endMonth <= mounthNum) {
			int result = new Integer(lastMonth);
			return result;
		}
		return 0;
	}
	
	private static int getMonthCount(int mounthNum, String date, String lastMonth) throws Exception {
		int endMonth = convertYToM(date);
		int computeStartMonth = convertYToM(DateHelper.getBusinessDate());
		if (endMonth >= computeStartMonth) return 1;
		if (computeStartMonth - endMonth <= mounthNum) {
			return 1;
		}
		return 0;
	}
	
	private static int getAheadMonthCount(int monthNum,String paymentBeginMonth, String overdueDate) throws Exception {
		int paymentMonth = convertYToM(paymentBeginMonth);
		int overdueMonth = convertYToM(overdueDate);
		if (overdueMonth < paymentMonth) { //如果逾期5年的月份小于最近24个月的贷款状态的第一个月的日期，则为最近5年的前36个月的月份
			return 1;
		}
		return 0;	    
	}

	private static int convertYToM(String date) {
		String year = date.substring(0, 4);
		String month = date.substring(5, 7);
		int result = new Integer(year) * 12 + new Integer(month);
		return result;
	}
	//交易日期 
	public static String getSystemDate() throws Exception{
		return DateHelper.getBusinessDate().replaceAll("/", "");
	}
	//交易时间
	public static String getSystemTime(){
		String time = DateX.format(new Date(), DateHelper.AMR_NOMAL_TIME_FORMAT);
		return time.substring(0, 2) + time.substring(3, 5) + time.substring(6, 8);
	}
	//获取时间戳
	public static String getSEQID() throws Exception{
		String nowTime = DateHelper.getBusinessTime();
		return nowTime.substring(0, 4) + "-" + nowTime.substring(5, 7) + "-" + nowTime.substring(8, 10)
				+ "-" + nowTime.substring(11, 13) + "." + nowTime.substring(14, 16) + "."
				+ nowTime.substring(17, 19);
	}

}
