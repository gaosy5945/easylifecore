package com.amarsoft.app.listener;

import java.io.InputStream;
import java.lang.management.ManagementFactory;
import java.util.Timer;
import java.util.TimerTask;

import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.awe.Configure;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.cache.CacheLoaderFactory;

public  class ReloadCache {
		static String startTime ="";
		
		static String startTimeT ="";
		static Configure CurConfig = null;
		
		static boolean startBool = true;
		
		static Transaction Sqlca =null;
		//��ѭʱ������
		public void reloadAllCacheSetTime() {
			Timer t = new Timer(); 
			t.schedule(new ReloadAllCache(), 10000, 60000);
		     }
		 //��ʱִ�м�����ѭ
		 private static class ReloadAllCache extends TimerTask
		 {		
			  public static int n = 0;
			  public void run()
			  {
				  if(n == 0){ n++; return;}
				  
				  ASResultSet rs = null;
				  //��ʼ��ʱ��
				  try{
				  //��ȡIP	
					 
					 if(CurConfig==null){
						  CurConfig = Configure.getInstance();
					 }
					 Sqlca = new Transaction(CurConfig.getDataSource());
					 
					 DateHelper.setBusinessDate(null);//���¼�������
					 String ip = ManagementFactory.getRuntimeMXBean().getName();
					 String sSql = "select serialNo from BAT_TASK_ERROR where ObjectType='reloadCache' and SerialNo='"+ip+"'";				
					 rs = Sqlca.getResultSet(sSql);
					 if (!rs.next()){//��ǰϵͳIP��������ִ��ˢ�����л���
						 
						 // InputStream in = this.getClass().getResourceAsStream("/WEB-INF/etc/cache.xml");
						  //CacheLoaderFactory.getInstance(in);
					      CacheLoaderFactory.reloadAll();
						  //����ǰϵͳIP�������ݿ�					  
						  String inSql = "insert into BAT_TASK_ERROR(SerialNo,ObjectType,ObjectNo) values('"+ip+"','reloadCache','"+ip+"')";
						  Sqlca.executeSQL(inSql);
					  }
					  rs.getStatement().close();
					  Sqlca.commit();
					  Sqlca.disConnect();
				  }
				  catch(Exception e)
				  {
					try
					{
						if(Sqlca != null) Sqlca.rollback();
						if(Sqlca != null) Sqlca.disConnect();
					}
					catch(Exception ex)
					{
						ex.printStackTrace();
					}
					e.printStackTrace();
					System.out.println(e.getMessage());
				  }
	
			 }
		
	}
 }
