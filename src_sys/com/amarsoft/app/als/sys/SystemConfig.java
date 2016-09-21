package com.amarsoft.app.als.sys;

import com.amarsoft.app.accounting.config.impl.AccountCodeConfig;
import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.base.config.impl.AppDataConfig;
import com.amarsoft.app.base.config.impl.BusinessComponentConfig;
import com.amarsoft.app.base.config.impl.CreditCheckConfig;
import com.amarsoft.app.base.config.impl.ErrorCodeConfig;
import com.amarsoft.app.base.config.impl.MerchandiseConfig;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.script.ScriptConfig;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.base.util.RateHelper;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.cache.AbstractCache;

public class SystemConfig extends AbstractCache{

	@Override
	public boolean load(Transaction arg0) throws Exception {
		// TODO Auto-generated method stub
		ScriptConfig.getInstance().init("{$ARE.PRD_HOME}/etc/app/script-config.xml",100);
		ErrorCodeConfig.getInstance().init("{$ARE.PRD_HOME}/etc/app/errorcode-config.xml",1000);
		TransactionConfig.getInstance().init("{$ARE.PRD_HOME}/etc/app/transaction-config.xml",1000);
		AccountCodeConfig.getInstance().init("{$ARE.PRD_HOME}/etc/app/accounting/accountcode-config.xml",1000);
		BusinessComponentConfig.getInstance().init("{$ARE.PRD_HOME}/etc/app/component/component-parameter-config.xml,{$ARE.PRD_HOME}/etc/app/component/component-config.xml",1000);
		FlowConfig.getInstance().init("{$ARE.PRD_HOME}/etc/app/workflow-config.xml",100);
		CashFlowConfig.getInstance().init("{$ARE.PRD_HOME}/etc/app/accounting/cashflow-config.xml",1000);
		CreditCheckConfig.getInstance().init("{$ARE.PRD_HOME}/etc/app/creditcheck-config.xml",100);
		MerchandiseConfig.getInstance().init("{$ARE.PRD_HOME}/etc/app/merchandise-config.xml",1000);
		AppDataConfig.getInstance().init("{$ARE.PRD_HOME}/etc/app/appdata-config.xml",100);
		RateHelper.clear();//清空利率信息
		DateHelper.setBusinessDate(null);//重置日期
		return true;
	}

	@Override
	public void clear() throws Exception {
		// TODO Auto-generated method stub
		
	}


}
