<?php include('conf/db.php') ?>
<div class="inner-area">
    <div class="pure-g">
        <div class="pure-u-1">
            <div class="content_box">

                <h3>Install RAMP</h3>
                <form class="pure-form-stacked pure-form install-form" method="post">
                    <fieldset>
                        <p>The form below saves your MySQL credentials.</p>
                        <p>You should also <a href="https://github.com/UMiamiLibraries/RAMP#12-create-the-ramp-database" target="_blank">create the RAMP database</a>.</p>                        
                        
                        <div>
                            <label>
                                Hostname
                                <input name="db_host" type="text" value="<?php echo $db_host; ?>" required>
                            </label>
                            <label>
                                Username
                                <input name="db_user" type="text" value="<?php echo $db_user; ?>" required>
                            </label>

                            <label>
                                Password
                                <input name="db_pass" type="text" value="<?php echo $db_pass; ?>" required>
                            </label>
                            <label>
                                Database Name
                                <input name="db_default" type="text" value="<?php echo $db_default; ?>"  required>
                            </label>
                            <label>
                                Port
                                <input name="db_port" type="text" value="<?php echo $db_port; ?>" required>
                            </label>
                            <input class="pure-button ramp-button action-button" type="submit" value="Install RAMP">
                        </div>
                    </fieldset>
                </form>
            </div>
        </div>
    </div>
</div>
