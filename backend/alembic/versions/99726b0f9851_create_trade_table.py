"""create trade table

Revision ID: 99726b0f9851
Revises: 
Create Date: 2025-04-26 17:55:10.411573

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '99726b0f9851'
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('trades',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('symbol', sa.String(), nullable=True),
    sa.Column('direction', sa.String(), nullable=True),
    sa.Column('entry_price', sa.Float(), nullable=True),
    sa.Column('exit_price', sa.Float(), nullable=True),
    sa.Column('size', sa.Float(), nullable=True),
    sa.Column('leverage', sa.Integer(), nullable=True),
    sa.Column('exchange', sa.String(), nullable=True),
    sa.Column('entry_time', sa.DateTime(), nullable=True),
    sa.Column('exit_time', sa.DateTime(), nullable=True),
    sa.Column('notes', sa.String(), nullable=True),
    sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_trades_id'), 'trades', ['id'], unique=False)
    # ### end Alembic commands ###


def downgrade() -> None:
    """Downgrade schema."""
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_index(op.f('ix_trades_id'), table_name='trades')
    op.drop_table('trades')
    # ### end Alembic commands ###
