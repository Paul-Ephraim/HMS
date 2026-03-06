use hos_ms;

alter table OT_Technician add constraint fk_technicianid FOREIGN KEY (Tech_Id) references Staff (Staff_Id)