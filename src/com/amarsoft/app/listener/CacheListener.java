package com.amarsoft.app.listener;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;


public class CacheListener implements ServletContextListener {

	public void contextDestroyed(ServletContextEvent arg0) {
	    System.out.println("�����ر�");
	     }

	public void contextInitialized(ServletContextEvent event) {
			ReloadCache rc = new ReloadCache();
			rc.reloadAllCacheSetTime();
	       System.out.println("�����������");
	     }
	}
