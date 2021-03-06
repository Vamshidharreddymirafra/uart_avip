`ifndef SLAVE_AGENT_INCLUDED_
`define SLAVE_AGENT_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: slave_agent
// This agent has sequencer, driver_proxy, monitor_proxy for UART
//--------------------------------------------------------------------------------------------
class slave_agent extends uvm_agent;
  `uvm_component_utils(slave_agent)
  
  // Variable: slave_agent_cfg_h;
  // Handle for slave agent configuration
  slave_agent_config slave_agent_cfg_h;

  // Variable: slave_seqr_h;
  // Handle for slave sequencer
  slave_sequencer slave_seqr_h;

  // Variable: slave_drv_proxy_h
  // Handle for slave driver proxy
  slave_driver_proxy slave_drv_proxy_h;

  // Variable: slave_mon_proxy_h
  // Handle for slave monitor proxy
  slave_monitor_proxy slave_mon_proxy_h;

  // Variable: slave_coverage
  // Decalring a handle for slave_coverage
  slave_coverage slave_cov_h;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "slave_agent", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass : slave_agent

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes the slave_agent class object
//
// Parameters:
//  name - instance name of the  slave_agent
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function slave_agent::new(string name = "slave_agent",uvm_component parent=null);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: build_phase
// Creates the required ports, gets the required configuration from config_db
//
// Parameters:
//  phase - stores the current phase
//--------------------------------------------------------------------------------------------
function void slave_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if(!uvm_config_db #(slave_agent_config)::get(this,"","slave_agent_config",slave_agent_cfg_h)) begin
    `uvm_fatal("FATAL_SA_AGENT_CONFIG", $sformatf("Couldn't get the slave_agent_config from config_db"));
  end
  if(slave_agent_cfg_h.is_active == UVM_ACTIVE) begin
    slave_drv_proxy_h = slave_driver_proxy::type_id::create("slave_drv_proxy_h",this);
    slave_seqr_h=slave_sequencer::type_id::create("slave_seqr_h",this);
  end
  slave_mon_proxy_h = slave_monitor_proxy::type_id::create("slave_mon_proxy_h",this);
  
  //coverage
  if(slave_agent_cfg_h.has_coverage) begin
    slave_cov_h = slave_coverage::type_id::create("slave_cov_h",this);
  end

endfunction : build_phase


//--------------------------------------------------------------------------------------------
// Function: connect_phase
// Description: it connects the components using TLM ports
//
// Parameters:
// phase - uvm phase
//--------------------------------------------------------------------------------------------
function void slave_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if(slave_agent_cfg_h.is_active == UVM_ACTIVE) begin
    slave_drv_proxy_h.slave_agent_cfg_h = slave_agent_cfg_h;
    slave_seqr_h.slave_agent_cfg_h = slave_agent_cfg_h;
    
    // Connecting the ports
    slave_drv_proxy_h.seq_item_port.connect(slave_seqr_h.seq_item_export);
    
    // connect monitor port to coverage
  end
  
  slave_mon_proxy_h.slave_agent_cfg_h = slave_agent_cfg_h;
  
  //slave_drv_proxy_h.seq_item_port.connect(slave_seqr_h.seq_item_export);
  //
  //coverage connections

endfunction : connect_phase

//--------------------------------------------------------------------------------------------
//Function: end_of_elaboration_phase
// <Description_here>
//
// Parameters:
// phase - uvm phase
//--------------------------------------------------------------------------------------------
function void slave_agent::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
endfunction  : end_of_elaboration_phase

//--------------------------------------------------------------------------------------------
// Function: start_of_simulation_phase
// <Description_here>
//
// Parameters:
// phase - uvm phase
//--------------------------------------------------------------------------------------------
function void slave_agent::start_of_simulation_phase(uvm_phase phase);
  super.start_of_simulation_phase(phase);
endfunction : start_of_simulation_phase

//--------------------------------------------------------------------------------------------
// Task: run_phase
// <Description_here>
//
// Parameters:
// phase - uvm phase
//--------------------------------------------------------------------------------------------
task slave_agent::run_phase(uvm_phase phase);
  
  phase.raise_objection(this, "slave_agent");
  
  super.run_phase(phase);

  // Work here
  // ...

  phase.drop_objection(this);

endtask : run_phase

`endif

