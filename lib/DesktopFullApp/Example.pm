package DesktopFullApp::Example;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;
# This action will render a template
sub welcome {
  my $self = shift;

  # Render template "example/welcome.html.ep" with message
  $self->render(msg => 'Welcome to the Mojolicious real-time web framework!');
}

sub kill {
  my $self = shift;  
  $self->res->code(301);
  my $c = $self->config;
  my $name = $c->{'name'};
  $self->redirect_to('http://www.google.com');
  $self->app->log->debug("Goodbye, $name.");
  $self->tx->on( finish => sub {exit} );
}

sub insert {
    my $self = shift;
    my $user = $self->param('name');
    my $age  = $self->param('age');
    my $dbh= $self->db;
    my $insert = eval { $dbh->prepare('INSERT INTO people VALUES (?,?)') };
    $insert->execute( $user, $age );
    $self->redirect_to('/');
}

1;
